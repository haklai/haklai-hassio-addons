# Use the official Node.js 16 image.
# See https://hub.docker.com/_/node
FROM node:16

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy local code to the container image.
COPY . .

# Install production dependencies.
RUN npm install express multer cors

# Expose port 3000
EXPOSE 8099

# Run the web service on container startup.
CMD [ "node", "server.js" ]

