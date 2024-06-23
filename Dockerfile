# Stage 1: Build
FROM node:14 AS build

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy local code to the container image.
COPY . .

# Stage 2: Production
FROM node:14-alpine AS production

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy only the necessary files from the build stage.
COPY --from=build /usr/src/app .

# Install only production dependencies.
RUN npm install --only=production

# Run the web service on container startup.
CMD [ "npm", "start" ]

# Inform Docker that the container listens on the specified port.
EXPOSE 3000
