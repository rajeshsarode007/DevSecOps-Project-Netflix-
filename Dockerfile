# --- Build Stage ---
FROM node:16.17.0-alpine AS builder

WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install

# Pass TMDB KEY during docker build
ARG VITE_APP_TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=$VITE_APP_TMDB_V3_API_KEY

# Copy code
COPY . .

# Build Vite project
RUN yarn build

# --- Serve Stage ---
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
