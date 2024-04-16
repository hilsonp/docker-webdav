# Docker WebDAV image with propfind-depth-infinity mode enabled

A tiny image running [gliderlabs/docker-alpine](https://github.com/gliderlabs/docker-alpine) Linux and [Lighttpd](https://www.lighttpd.net/).

## Credits
This image is based on jgeusebroek/webdav. Most credits goes to him !
At the time of writing, it did not have the propfind-depth-infinity enabled which I needed.
As I wanted to train myself on an image creation, I forked and updated my own version.
## Usage

	docker run --restart=always -d
		-p 0.0.0.0:80:80 \
		--hostname=webdav \
		--name=webdav \
		-v /<host_directory_to_share>:/webdav \
		hilsonp/webdav-infinity

By default the WebDAV server is password protected with user `webdav` and password `vadbew` which obviously isn't really secure.
This can easily be overwritten, by creating a `config directory` on the host with an *htpasswd* file and mounting this as a volume on `/config`.

	-v /<host_config_directory>:/config

You can generate the htpasswd hash with this command line once the container is running:
    sudo docker exec -it e52512aef8c8 htpasswd -n myusername
    New password: \****
    Re-type new password: \****
    myusername:$apr1$vQglWPMm$FsYZpdyC6r3AwH/Zf9X9V0

Then simply copy this line into a htpasswd file in the config directory and restart the container.

You can also provide a list of IP's in the form of a regular expression which are then whitelisted. See below.

## Optional environment variables

* `USER_UID` User ID of the lighttpd daemon account (default: 2222).
* `USER_GID` Group ID of the lighttpd daemon account (default: 2222).
* `WHITELIST` Regexp for a list of IP's (default: none). Example: `-e WHITELIST='192.168.1.*|172.16.1.2'`
* `READWRITE` When this is set to `true`, the WebDAV share can be written to (default: False). Example: `-e READWRITE=true`

**IMPORTANT**: Should you use a persistent config volume, the WHITELIST and READWRITE variables will only have effect the first time. I.e., when you don't have a (custom) configuration yet.

## Docker Compose file
```
version: "3.8"
services:
  webdav-infinity:
    container_name: webdav-infinity
    image: hilsonp/webdav-infinity
    restart: unless-stopped
    ports:
      - 5005:80 # This makes the container listen on port 5005
    environment:
      - USER_UID=${DOCKER_UID}
      - USER_GID=${DOCKER_GID}
      - TZ=${DOCKER_TZ}
      - READWRITE=true
    volumes:
      - ./webdav/data:/webdav
      - ./webdav/config:/config
networks: {}
```
## License

MIT / BSD

## Author Information

Pierre Hilson based on work of [Jeroen Geusebroek](http://jeroengeusebroek.nl/)