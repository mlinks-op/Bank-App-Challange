# FROM node:alpine3.16 As build
# WORKDIR /client
# COPY . .
# RUN npm install
# RUN npm run build

# FROM nginx:1.19.0 As run
# COPY --from=build /client/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]



# ---- Build stage ----
FROM node:22-alpine AS build
WORKDIR /client
 
# Install dependencies first (cached unless package files change)
COPY package*.json ./
RUN npm ci
 
# Build the app
COPY . .
RUN npm run build
 
# ---- Run stage ----
FROM nginx:1.27-alpine AS run
COPY --from=build /client/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
 
