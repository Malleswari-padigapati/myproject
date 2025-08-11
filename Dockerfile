# Stage 1: Build Flutter web app
FROM cirrusci/flutter:latest AS build

WORKDIR /app

COPY pubspec.yaml pubspec.yaml
COPY lib lib/
COPY web web/

RUN flutter config --enable-web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve with nginx
FROM nginx:stable-alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
