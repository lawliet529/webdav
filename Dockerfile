FROM debian:stable-slim

RUN apt-get update && apt-get install -y nginx-extras whois

COPY ./entrypoint.sh /entrypoint.sh

COPY ./default.conf /etc/nginx/sites-enabled/default

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]