package router

import (
	"github.com/gorilla/mux"
	"github.com/jobinjose01/components/auth"
	"github.com/jobinjose01/components/parcelorder"
	"github.com/jobinjose01/helpers/jwt"
)

func Router() *mux.Router {

	router := mux.NewRouter()
	subrouter := router.PathPrefix("/api").Subrouter()
	subrouter.HandleFunc("/auth/login", auth.Login).Methods("POST")
	subrouter.HandleFunc("/parcel/create", jwt.TokenMiddleware(parcelorder.Create)).Methods("POST")
	subrouter.HandleFunc("/parcel/pickup", jwt.TokenMiddleware(parcelorder.PickUpParcel)).Methods("POST")
	subrouter.HandleFunc("/parcel/delivery", jwt.TokenMiddleware(parcelorder.DeliveryParcel)).Methods("POST")
	subrouter.HandleFunc("/parcel/list", jwt.TokenMiddleware(parcelorder.GetMyParcelList)).Methods("GET")
	subrouter.HandleFunc("/parcel/bikerslist", jwt.TokenMiddleware(parcelorder.GetBikerParcelList)).Methods("GET")
	return subrouter
}
