#!/bin/sh

/app/tailscaled --tun=userspace-networking  &
until /app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${HOSTNAME}
do
    sleep 0.1
done
echo Tailscale started

supervisord -c /app/supervisord.conf

