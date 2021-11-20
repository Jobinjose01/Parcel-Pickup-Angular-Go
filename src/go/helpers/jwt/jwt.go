package jwt

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/joho/godotenv"
)

type Error struct {
	Status  int    `json:"status"`
	Message string `json:"message"`
}

func SetError(err Error, message string) Error {
	err.Status = 0
	err.Message = message
	return err
}

func GenerateJWT(name string, groups int, userId uint) (string, error) {
	err := godotenv.Load()

	if err != nil {
		log.Fatal("Error loading .env file")
	}
	var mySigningKey = []byte(os.Getenv("JWT_SECRET"))
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["authorized"] = true
	claims["groups"] = groups
	claims["full_name"] = name
	claims["id"] = userId
	claims["user_id"] = userId
	//ttl, _ := strconv.ParseInt(os.Getenv("JWT_TTL"))
	claims["exp"] = time.Now().Add(time.Minute * 2500).Unix()

	tokenString, err := token.SignedString(mySigningKey)
	if err != nil {
		fmt.Errorf("Something went Wrong: %s", err.Error())
		return "", err
	}

	return tokenString, nil
}

func ParseJWTToken(w http.ResponseWriter, r *http.Request) (jwt.MapClaims, bool) {

	hmacSecret := []byte(os.Getenv("JWT_SECRET"))

	tokens := r.Header.Get("Authorization")

	if tokens == "" {
		log.Printf("Invalid JWT Token")
		return nil, false
	}

	token, err := jwt.Parse(r.Header["Authorization"][0], func(token *jwt.Token) (interface{}, error) {
		return hmacSecret, nil
	})

	if err != nil {
		return nil, false
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
		return claims, true
	} else {
		log.Printf("Invalid JWT Token")
		return nil, false
	}

}

func GetUserIdJWT(w http.ResponseWriter, r *http.Request) uint {

	var userId float64 = 0
	claim, ok := ParseJWTToken(w, r)
	if ok {
		userId = claim["id"].(float64)
	}
	return uint(userId)
}

func TokenMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		_, ok := ParseJWTToken(w, r)
		if !ok {

			http.Error(w, "Forbidden", http.StatusForbidden)

		}

		next.ServeHTTP(w, r)
		return
	}
}
