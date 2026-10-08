# Use Node 16 as the base image for the application
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to cache dependencies
COPY package*.json ./

# Install production dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Expose the port the app runs on
EXPOSE 8081

# Command to run the application
CMD [ "npm", "start" ]