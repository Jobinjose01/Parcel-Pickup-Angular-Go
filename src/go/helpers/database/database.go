package database

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func Connect() *gorm.DB {

	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}
	con := os.Getenv("DATABASE_USER") + ":" + os.Getenv("DATABASE_PASSWORD") + "@tcp(" + os.Getenv("DATABASE_HOST") + ":" + os.Getenv("DATABASE_PORT") + ")/" + os.Getenv("DATABASE_NAME") + "?charset=utf8mb4&parseTime=True&loc=Local"
	connection, err := gorm.Open(mysql.Open(con), &gorm.Config{})
	if err != nil {

		log.Fatal("Database connection Failed")
	}
	sqldb, _ := connection.DB()
	err = sqldb.Ping()
	if err != nil {
		log.Fatal("database connected")
	}

	return connection
}

func InitialMigration() {
	/* connection := GetDatabase()
	defer Closedatabase(connection)
	connection.AutoMigrate(User{}) */
}

func Closedatabase(connection *gorm.DB) {
	sqldb, _ := connection.DB()
	sqldb.Close()
}
