FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
COPY . .

# 🔥 Correct Vite variable name
ARG TMDB_V3_API_KEY
ENV VITE_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}

# Optional but good
ENV VITE_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build

# ─────────────────────────────
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

COPY --from=builder /app/dist .
