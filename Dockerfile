FROM golang:1.16.2-alpine3.13 as builder
WORKDIR /app
COPY . ./

FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.18.1_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1
COPY . ./

FROM alpine:latest
RUN	apk update && apk add ca-certificates \
	samba-common-tools \
	samba \
	supervisor \
	&& rm -rf /var/cache/apk/*

COPY --from=builder /app/start.sh /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
COPY smb.conf /app/
COPY supervisord.conf /app/
RUN	mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
RUN chmod +x /app/start.sh
# 137, 138 for nmbd and 139, 445 for smbd
EXPOSE 135/tcp 137/udp 138/udp 139/tcp 445/tcp

ENTRYPOINT ["/app/start.sh"]
