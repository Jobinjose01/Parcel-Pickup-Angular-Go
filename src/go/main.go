package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"

	"github.com/jobinjose01/router"
	"github.com/rs/cors"
)

func main() {

	fmt.Println("Go Server Is Up")
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	router := router.Router()

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{os.Getenv("ORIGIN_ALLOWED")},
		AllowedHeaders:   []string{"X-Requested-With", "Content-Type", "Authorization"},
		AllowedMethods:   []string{"GET", "HEAD", "POST", "PUT", "OPTIONS"},
		AllowCredentials: true,
	})
	handler := c.Handler(router)
	fmt.Println("Server is getting started... on:" + os.Getenv("GO_SERVER_PORT"))
	log.Fatal(http.ListenAndServe(":"+os.Getenv("GO_SERVER_PORT"), handler))

}
