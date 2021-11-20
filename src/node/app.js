const server = require('http').Server();

const io = require('socket.io')(server);

const Redis = require('ioredis');

const dotenv = require('dotenv');

dotenv.config();

const redis = new Redis({
         port: process.env.REDIS_PORT,
         host: process.env.REDIS_HOST,
         db : 0
     });

redis.subscribe('parcel-channel');

redis.on('message', function (channel, message) {
    console.log(message)
    const event = JSON.parse(message);
    io.emit(channel, event);
});

server.listen({
    port: process.env.NODE_SERVER_PORT
});