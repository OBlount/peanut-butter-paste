FROM alpine:latest
WORKDIR /usr/peanut-butter
COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh
CMD [ "ls", "-la" ]
ENTRYPOINT ["/usr/peanut-butter/entrypoint.sh"]