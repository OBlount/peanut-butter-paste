FROM alpine:latest
WORKDIR /usr/peanut-butter
COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]