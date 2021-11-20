#get a base image
FROM golang:1.17-alpine

WORKDIR /go/src/app
COPY ./src/go/ .

RUN go get -d -v
RUN go build -v

CMD ["./angular-go"]