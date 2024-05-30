FROM scratch AS build1
LABEL maintainer="Maciej Przyłucki"
# import struktury alpine do obrazu scratch
ADD alpine-minirootfs-3.19.1-x86_64.tar /
# dodanie argumentu i przypisanie go do zmiennej środowiskowej, wartość domyślna to "latest"
ARG BASE_VERSION
ENV APP_VERSION=${BASE_VERSION:-latest}
# dodanie pakietu nodejs npm
RUN apk add --update nodejs npm && \
    rm -rf /var/cache/apk/*
WORKDIR /app
# skopiowanie aplikacji serwera do folderu /app
COPY src ./
RUN npm install

# syntax=docker/dockerfile:1
FROM nginx:alpine
ARG BASE_VERSION
ENV APP_VERSION=${BASE_VERSION:-latest}
# zawarcie sekretnego pliku
RUN --mount=type=secret,id=mysecret,dst=/hidden.txt
# skopiowanie pliku konfiguracyjnego nginx z odpowiednimi ustawieniami
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
# skopiowanie aplikacji serwera z pierwszego etapu do odpowiedniego folderu
COPY --from=build1 /app ./
# dodanie curl i nodejs npm
RUN apk add --update curl && \
    apk add --update nodejs npm && \
    rm -rf /var/cache/apk/*
EXPOSE 8080
# weryfikacja działania aplikacji
HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -f http://localhost:8080/ || exit 1
CMD ["npm", "start", "-g", "daemon off"]