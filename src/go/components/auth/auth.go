package auth

import (
	"encoding/json"
	"net/http"
	"time"

	"github.com/jinzhu/gorm"
	"github.com/jobinjose01/helpers/database"
	"github.com/jobinjose01/helpers/jwt"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	gorm.Model
	ID              uint      `json:"id"`
	Name            string    `json:"name"`
	Email           *string   `gorm:"unique" json:"email"`
	EmailVerifiedAt time.Time `json:"-"`
	Password        string    `json:"-"`
	Groups          int       `json:"groups"`
	Status          int       `json:"status"`
	ApiToken        string    `json:"api_token"`
	RememberToken   string    `json:"-"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
	DeletedAt       time.Time `gorm:"index" json:"deleted_at"`
}

type Authentication struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type Error struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
}

func SetError(err Error, message string) Error {
	err.Status = 0
	err.Message = message
	return err
}

func Login(w http.ResponseWriter, r *http.Request) {

	connection := database.Connect()
	defer database.Closedatabase(connection)

	var credentials Authentication

	err := json.NewDecoder(r.Body).Decode(&credentials)

	if err != nil {
		var err Error
		err = SetError(err, "Error in reading payload.")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	var authUser User
	connection.Where("email = 	?", credentials.Email).First(&authUser)

	if credentials.Email == "" {
		var err Error
		err = SetError(err, "Username or Password is incorrect")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return

	}

	check := CheckPasswordHash(credentials.Password, authUser.Password)

	if !check {
		var err Error
		err = SetError(err, "Username or Password is incorrect")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	validToken, err := jwt.GenerateJWT(authUser.Name, authUser.Groups, authUser.ID)
	if err != nil {
		var err Error
		err = SetError(err, "Failed to generate token")
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(err)
		return
	}

	data := make(map[string]string)
	data["status"] = "1"
	data["message"] = "login successfull"
	data["token_type"] = "bearer"
	data["access_token"] = validToken

	w.Header().Set("content-Type", "application/json")
	json.NewEncoder(w).Encode(data)

}

func GeneratehashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), 14)
	return string(bytes), err
}

func CheckPasswordHash(password, hash string) bool {
	err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
	return err == nil
}
