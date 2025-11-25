FROM node:16.17.0-alpine as builder
WORKDIR /app

COPY package.json .
COPY yarn.lock .

# Install dependencies
RUN yarn install

# Install TypeScript because tsc is required during build
RUN yarn add -D typescript

# Copy rest of project files
COPY . .

# Pass build ARG
ARG TMDB_V3_API_KEY
ENV VITE_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}

ENV VITE_API_ENDPOINT_URL="https://api.themoviedb.org/3"

# Build the project
RUN yarn build

# ─────────────────────────────
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
