FROM node:14-alpine

# Create app directory
WORKDIR /app

# Install app dependencies
COPY ./src/node/package*.json /src/node/app.js ./src/node/.env ./

RUN npm install

# Expose the port and start the application
Expose 3000

CMD ["node", "app.js"]