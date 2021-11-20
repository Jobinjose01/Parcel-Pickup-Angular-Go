package redisdb

import (
	"context"
	"log"
	"os"

	"github.com/go-redis/redis/v8"
	"github.com/joho/godotenv"
)

var ctx = context.Background()

func Connect() *redis.Client {

	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}
	client := redis.NewClient(&redis.Options{
		Addr:     os.Getenv("REDIS_HOST") + ":" + os.Getenv("REDIS_PORT"),
		Password: "", //os.Getenv("REDIS_PASSWORD"), // no password set
		DB:       0,  // use default DB
	})

	if err := client.Ping(ctx).Err(); err != nil {
		log.Printf("Redis Connection Error")
	}

	return client
}
