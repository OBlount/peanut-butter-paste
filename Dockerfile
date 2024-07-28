FROM alpine:latest
RUN apk update && apk add curl
WORKDIR /usr/peanut-butter
COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["/usr/peanut-butter/entrypoint.sh"]