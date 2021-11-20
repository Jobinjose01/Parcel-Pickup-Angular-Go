# Pickup Aand Delivery App

This app have two user groups senders and bikers , Senders can create pickup required and bikers can accept pickup and deliver.
This same application is available as PHP Laravel + Angular [here](https://github.com/Jobinjose01/Parcel-Pickup-Angular-Laravel)

You have to import the given [SQL](https://github.com/Jobinjose01/Parcel-Pickup-Angular-Go/blob/master/db.sql) file for the Database , once the docker is up you can access the mysql db with `127.0.0.1:3307` and `root` as username and password 

Already created 5 senders and 10 bikers , You can create and manage user roles from this admin panel if required.

### Angular Front End

`http://localhost:81/`

Angular app build is placed dist folder and it will copy to the ngx container.
The app is handled with `socket.io` package to get dynamic update on the status so there is no need to refresh the page. Angular source
code is placed inside `angular` folder under src

front end login details are below , there are 5 senders and 10 bikers same password.

`sender1@wwm.com/123456`
`biker1@wwm.com/123456`


### Deployment

The deployment can be docker or any other way as you like.

### Built With

* [Go](https://golang.org/) - The API framework used.
* [Npm](https://www.npmjs.com/) - Dependency Management for Angular and NodeJS.
* [Angular](https://angular.io/) - Front-end of the application buit with Angular 12.x.
* [NodeJs](https://nodejs.org/en/about/) - Node Js is used for socket Service with Redis.
* [Redis](https://redis.io/) - Redis is used for channel publish and better performance.
* [MySql](https://www.mysql.com/) - Primary database for the laravel application.
* [Docker](https://www.docker.com/) - Everything is containerized using docker.

## Author

[Jobin Jose](https://github.com/Jobinjose01)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details





