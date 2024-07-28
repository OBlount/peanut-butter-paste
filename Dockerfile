FROM alpine:latest
RUN apt-get update && apt-get install -y \
curl
WORKDIR /usr/peanut-butter
COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["/usr/peanut-butter/entrypoint.sh"]