# Standalone Docker Samba Server with Tailscale support
Can be used to quickly setup a Samba Server and sharing that wth friends over [Tailscale](https://tailscale.com/)

## Info
By default the included `smb.conf` file has the `\\$HOST_IP\data` Share with **writable Guests allowed**
If you don't want this you need to provide your own config file.

## Prerequisites 
 - you need a Tailscale Auth Key from https://login.tailscale.com/admin/authkeys as outlined in https://tailscale.com/kb/1085/auth-keys/
 - **only use one-time Keys for security**

## Configuration
### Docker Compose Example

```yml
---
version: "2"
services:
  samba-tailscale:
    image: ghcr.io/niklasthegeek/docker-smb-tailscale
    container_name: smb-tailscale
    hostname: smb-tailscale # defines the name shown on the Tailscale Admin Dashboard
    environment:
      - TAILSCALE_AUTHKEY=tskey-abcdef1432341818 # put your Tailscale Auth Key here 
    volumes:
      #- /some/path/:/data      #uncomment for writable share
      #- /some/path/:/data:ro   #uncomment for read only share
      #- /some/path/smb.conf:/app/smb.conf # if you want to povide your own config add shares with volumes accordingly
    restart: unless-stopped
   
 ```
### Docker Cli

Run with defaults(writable `/data` Share)
```
docker run -d --name=smb-tailscale --hostname=smb-tailscale -v /some/path/:/data -e TAILSCALE_AUTHKEY=tskey-abcdef1432341818  ghcr.io/niklasthegeek/docker-smb-tailscale
```
Read only share

```
docker run -d --name=smb-tailscale --hostname=smb-tailscale -v /some/path/:/data:ro -e TAILSCALE_AUTHKEY=tskey-abcdef1432341818  ghcr.io/niklasthegeek/docker-smb-tailscale
```

With user-provided smb.conf
```
docker run -d --name=smb-tailscale --hostname=smb-tailscale -v /some/path/:/data -v /some/path/smb.conf:/app/smb.conf -e TAILSCALE_AUTHKEY=tskey-abcdef1432341818  ghcr.io/niklasthegeek/docker-smb-tailscale
```
## License

The repository is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
