# Stage 1: Build the Angular app
FROM node:18 AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build --omit=dev

# Stage 2: Serve the Angular app with Nginx
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
RUN npm install angular-http-server -g
EXPOSE 3001
CMD [ "angular-http-server" , "--path=/app/dist/frontend/browser", "-p" , "3001"]