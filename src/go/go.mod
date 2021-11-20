module github.com/jobinjose01/angular-go

go 1.17

require (
	github.com/cespare/xxhash/v2 v2.1.2 // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/go-redis/redis/v8 v8.11.4 // indirect
	github.com/go-sql-driver/mysql v1.6.0 // indirect
	github.com/gorilla/mux v1.8.0 // indirect
	github.com/jinzhu/gorm v1.9.16 // indirect
	github.com/jinzhu/inflection v1.0.0 // indirect
	github.com/jinzhu/now v1.1.2 // indirect
	github.com/jobinjose01/components/auth v0.0.0-00010101000000-000000000000 // indirect
	github.com/jobinjose01/components/parcelorder v0.0.0-00010101000000-000000000000 // indirect
	github.com/jobinjose01/helpers/database v0.0.0-00010101000000-000000000000 // indirect
	github.com/jobinjose01/helpers/redisdb v0.0.0-00010101000000-000000000000 // indirect
	github.com/jobinjose01/helpers/jwt v0.0.0-00010101000000-000000000000 // indirect
	golang.org/x/crypto v0.0.0-20211108221036-ceb1ce70b4fa // indirect
	gorm.io/driver/mysql v1.1.3 // indirect
	gorm.io/gorm v1.22.2 // indirect
)

require (
	github.com/jobinjose01/router v1.0.0
	github.com/joho/godotenv v1.4.0
	github.com/rs/cors v1.8.0
)

replace github.com/jobinjose01/router => ./router

replace github.com/jobinjose01/components/auth => ./components/auth

replace github.com/jobinjose01/components/parcelorder => ./components/parcelorder

replace github.com/jobinjose01/helpers/database => ./helpers/database

replace github.com/jobinjose01/helpers/redisdb => ./helpers/redisdb

replace github.com/jobinjose01/helpers/jwt => ./helpers/jwt
