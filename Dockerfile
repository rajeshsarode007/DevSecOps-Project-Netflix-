FROM node:16.17.0-alpine as builder
WORKDIR /app

COPY package.json .
COPY yarn.lock .

RUN yarn install

# Add this !!!!!
ARG VITE_TMDB_V3_API_KEY
ENV VITE_TMDB_V3_API_KEY=$VITE_TMDB_V3_API_KEY

COPY . .

RUN yarn build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
