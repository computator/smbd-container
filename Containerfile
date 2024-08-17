FROM docker.io/library/alpine

LABEL org.opencontainers.image.source=https://github.com/computator/smbd-container

RUN apk add --no-cache samba-server samba-common-tools tini
COPY entrypoint.sh /
COPY smb.conf default-share.conf /etc/samba/

WORKDIR /srv
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 445
