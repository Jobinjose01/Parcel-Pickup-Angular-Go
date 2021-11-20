package parcelorder

import (
	"context"
	"crypto/rand"
	"database/sql"
	"database/sql/driver"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/jinzhu/gorm"
	"github.com/jobinjose01/helpers/database"
	"github.com/jobinjose01/helpers/jwt"
	"github.com/jobinjose01/helpers/redisdb"
)

type ParcelOrder struct {
	gorm.Model
	ID                 int                `json:"id"`
	SenderId           uint               `json:"sender_id"`
	OrderID            string             `json:"order_id"`
	PickupAddress      string             `json:"pickup_address"`
	DeliveryAddress    string             `json:"delivery_address"`
	CreatedAt          time.Time          `json:"created_at"`
	UpdatedAt          time.Time          `json:"updated_at"`
	DeletedAt          sql.NullTime       `gorm:"sql.NullTime"; json:"deleted_at,omitempty"`
	ParcelOrderDetails ParcelOrderDetails `gorm:"foreignKey:ParcelOrderID"`
}
type ParcelOrderDetails struct {
	gorm.Model
	ID            int           `json:"id"`
	BikerID       sql.NullInt32 `json:"biker_id"`
	ParcelOrderID int           `json:"parcel_order_id"`
	PickupTime    NullTime      `gorm:"default:NULL" json:"pickup_time,omitempty"`
	DeliveryTime  NullTime      `gorm:"default:NULL" json:"delivery_time,omitempty"`
	Status        StatusLabel   `gorm:"default:0" json:"status"`
	CreatedAt     time.Time     `json:"created_at"`
	UpdatedAt     time.Time     `json:"updated_at"`
	DeletedAt     sql.NullTime  `gorm:"index" json:"deleted_at,omitempty"`
}

func (ParcelOrderDetails) TableName() string {
	return "parcel_order_details"
}
func (ParcelOrder) TableName() string {
	return "parcel_orders"
}

var ctx = context.Background()

type StatusLabel struct {
	int64
}
type NullTime struct {
	Time  time.Time
	Valid bool // Valid is true if Time is not NULL
}

func (j *NullTime) Scan(src interface{}) error {
	if t, ok := src.(time.Time); ok {
		j.Time = t
		j.Valid = true
	}
	return nil
}
func (j NullTime) Value() (driver.Value, error) {
	return j.Time, nil
}

func (nt *NullTime) MarshalJSON() ([]byte, error) {
	if !nt.Valid {
		return []byte("null"), nil
	}
	val := fmt.Sprintf("\"%s\"", nt.Time.Format(time.RFC1123))
	return []byte(val), nil
}

func (st *StatusLabel) Scan(src interface{}) error {
	if t, ok := src.(int64); ok {
		st.int64 = t
	}
	return nil

}

func (st StatusLabel) Value() (driver.Value, error) {
	return st.int64, nil
}

func (st *StatusLabel) MarshalJSON() ([]byte, error) {
	var val string
	if st.int64 == 0 {
		val = fmt.Sprintf("\"%s\"", "Pending")
	}
	if st.int64 == 1 {
		val = fmt.Sprintf("\"%s\"", "Picked")
	}
	if st.int64 == 2 {
		val = fmt.Sprintf("\"%s\"", "Delivered")
	}
	return []byte(val), nil
}

type PickUp struct {
	PickupAddress   string `json:"pickup_address"`
	DeliveryAddress string `json:"delivery_address"`
	PickupTime      string `json:"pickup_time"`
	DeliveryTime    string `json:"delivery_time"`
	ParcelOrderId   int    `json:"parcel_order_id"`
}

type RedisData struct {
	MessageType     string      `json:"message_type"`
	Message         string      `json:"message"`
	DeliveredUserId int32       `json:"delivered_user_id"`
	Data            ParcelOrder `json:"data"`
}

func (rd RedisData) MarshalBinary() ([]byte, error) {
	return json.Marshal(rd)
}

type Error struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
}

func SetSuccess(msg Error, message string) Error {
	msg.Status = 1
	msg.Message = message
	return msg
}

func SetError(err Error, message string) Error {
	err.Status = 0
	err.Message = message
	return err
}

func Create(w http.ResponseWriter, r *http.Request) {

	connection := database.Connect()
	defer database.Closedatabase(connection)

	redisdb := redisdb.Connect()

	var pickupdata PickUp

	err := json.NewDecoder(r.Body).Decode(&pickupdata)

	if err != nil {
		var err Error
		err = SetError(err, "Error in reading payload.")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	if pickupdata.PickupAddress == "" || pickupdata.DeliveryAddress == "" {
		var err Error
		err = SetError(err, "Please provide the pickup and delivery address")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return

	}

	userId := jwt.GetUserIdJWT(w, r)

	order := ParcelOrder{
		DeliveryAddress:    pickupdata.DeliveryAddress,
		PickupAddress:      pickupdata.PickupAddress,
		OrderID:            GetUniqueID(),
		SenderId:           userId,
		ParcelOrderDetails: ParcelOrderDetails{},
	}

	connection.Create(&order)

	orderDetails := ParcelOrderDetails{
		ParcelOrderID: order.ID,
	}
	connection.Create(&orderDetails)
	var result ParcelOrder

	var redisdata RedisData
	redisdata.MessageType = "create"
	redisdata.Data = order
	redisdata.Message = "New Parcel Request Created!"
	redisdb.Publish(ctx, "parcel-channel", redisdata).Err()

	connection.First(&result, &order.ID)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(&order)

}

func PickUpParcel(w http.ResponseWriter, r *http.Request) {

	db := database.Connect()
	defer database.Closedatabase(db)
	redisdb := redisdb.Connect()

	var pickupdata PickUp

	err := json.NewDecoder(r.Body).Decode(&pickupdata)

	if err != nil {
		var err Error
		err = SetError(err, "Error in reading payload.")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	if pickupdata.ParcelOrderId == 0 {
		var err Error
		err = SetError(err, "Please provide a valid pickup date")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return

	}

	dt, err := time.Parse("02-01-2006 15:04:05", pickupdata.PickupTime)

	if err != nil {
		fmt.Println(err)
		var err Error
		err = SetError(err, "Invalid Pickup Date Time!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	if !CheckParcelPickupStatus(pickupdata.ParcelOrderId) {
		var err Error
		err = SetError(err, "This parcel already picked!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}
	//pickup_time := dt.Format("02-01-2006 15:04:05")

	userId := jwt.GetUserIdJWT(w, r)

	orderDetails := ParcelOrderDetails{
		Status:     StatusLabel{int64: 1},
		BikerID:    sql.NullInt32{Int32: int32(userId), Valid: true},
		PickupTime: NullTime{Time: dt, Valid: true},
	}

	var order ParcelOrder
	var redisdata RedisData
	db.Where("id = ?", pickupdata.ParcelOrderId).Find(&order)
	redisdata.MessageType = "pickup"
	redisdata.Data = order
	redisdata.Message = "Parcel Status Updated!"
	redisdb.Publish(ctx, "parcel-channel", redisdata).Err()

	result := db.Model(&ParcelOrderDetails{}).Where("parcel_order_id = ?", pickupdata.ParcelOrderId).Updates(&orderDetails)

	if result.RowsAffected == 1 {
		var msg Error
		msg = SetSuccess(msg, "The parcel status updated!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(msg)
		return
	} else {
		var err Error
		err = SetError(err, "The parcel status cannot update !")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}
	if result.Error != nil {
		var err Error
		err = SetError(err, "The parcel status cannot update !")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}
}

func DeliveryParcel(w http.ResponseWriter, r *http.Request) {

	db := database.Connect()
	defer database.Closedatabase(db)
	redisdb := redisdb.Connect()
	var pickupdata PickUp

	err := json.NewDecoder(r.Body).Decode(&pickupdata)

	if err != nil {
		var err Error
		err = SetError(err, "Error in reading payload.")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	if pickupdata.ParcelOrderId == 0 {
		var err Error
		err = SetError(err, "Please provide a valid pickup date")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return

	}

	dt, err := time.Parse("02-01-2006 15:04:05", pickupdata.DeliveryTime)

	if err != nil {
		fmt.Println(err)
		var err Error
		err = SetError(err, "Invalid Delivery Date Time!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	userId := jwt.GetUserIdJWT(w, r)

	if !CheckParcelDeliveryStatus(pickupdata.ParcelOrderId, int32(userId)) {
		var err Error
		err = SetError(err, "This parcel already delivered or not yet picked!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	orderDetails := ParcelOrderDetails{
		Status:       StatusLabel{int64: 2},
		DeliveryTime: NullTime{Time: dt, Valid: true},
	}

	var order ParcelOrder
	var redisdata RedisData
	db.Where("id = ?", pickupdata.ParcelOrderId).Find(&order)
	redisdata.MessageType = "delivery"
	redisdata.Data = order
	redisdata.Message = "Parcel Status Updated!"
	redisdata.DeliveredUserId = int32(userId)
	redisdb.Publish(ctx, "parcel-channel", redisdata).Err()

	result := db.Model(&ParcelOrderDetails{}).Where("parcel_order_id = ?", pickupdata.ParcelOrderId).Updates(&orderDetails)

	if result.RowsAffected == 1 {
		var msg Error
		msg = SetSuccess(msg, "The parcel status updated!")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(msg)
		return
	} else {
		var err Error
		err = SetError(err, "The parcel status cannot update !")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}
	if result.Error != nil {
		var err Error
		err = SetError(err, "The parcel status cannot update !")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}
}

func CheckParcelPickupStatus(parcel_order_id int) bool {
	connection := database.Connect()
	defer database.Closedatabase(connection)
	var order ParcelOrderDetails
	result := connection.Where("parcel_order_id = ? AND biker_id IS NULL AND  pickup_time IS NULL AND status = ?", parcel_order_id, 0).Find(&order)
	if result.RowsAffected == 0 {
		return false
	} else {
		return true
	}
}

func CheckParcelDeliveryStatus(parcel_order_id int, userId int32) bool {

	connection := database.Connect()
	defer database.Closedatabase(connection)
	var order ParcelOrderDetails
	result := connection.Where("parcel_order_id = ? AND biker_id = ? AND  status = ?", parcel_order_id, userId, 1).Find(&order)
	if result.RowsAffected == 0 {
		return false
	} else {
		return true
	}
}
func GetMyParcelList(w http.ResponseWriter, r *http.Request) {

	connection := database.Connect()
	defer database.Closedatabase(connection)

	userId := jwt.GetUserIdJWT(w, r)

	var orders []ParcelOrder
	connection.Preload("ParcelOrderDetails").Where("sender_id = ?", userId).Order("id desc").Find(&orders)

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(orders)

}

func GetBikerParcelList(w http.ResponseWriter, r *http.Request) {

	connection := database.Connect()
	defer database.Closedatabase(connection)

	userId := jwt.GetUserIdJWT(w, r)

	var orders []ParcelOrder
	connection.Preload("ParcelOrderDetails", "biker_id = ? OR biker_id IS NULL", userId).Order("id desc").Find(&orders)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(orders)
}

func GetUniqueID() string {
	n := 5
	b := make([]byte, n)
	if _, err := rand.Read(b); err != nil {
		panic(err)
	}
	s := fmt.Sprintf("%X", b)
	return s
}
