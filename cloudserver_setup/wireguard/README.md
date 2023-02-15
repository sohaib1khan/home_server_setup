## Wireguard: docker-compose deployment

This is a Docker Compose file that defines a single service named "wireguard" that runs a Wireguard VPN server container using the `lscr.io/linuxserver/wireguard` image. Here are some explanations of the various sections and options in the file:

In this configuration, there is only one service defined, which is the WireGuard VPN server. The `image` parameter specifies the Docker image to use, which is the latest version of the `lscr.io/linuxserver/wireguard` image. The `container_name` parameter sets the name of the container to `wireguard-1`.

The `cap_add` parameter grants the container additional Linux capabilities, which are required for setting up the VPN. The `environment` parameter sets several environment variables for the container, including the `PUID` and `PGID` user and group IDs, `TZ` timezone, `SERVERURL` for the server URL, `SERVERPORT` for the server port, `PEERS` for the number of peers, `PEERDNS` for the peer DNS server, `INTERNAL_SUBNET` for the internal subnet, and `ALLOWEDIPS` for the allowed IPs.

The `volumes` parameter maps the `/config` directory inside the container to a local directory in the host system, which can be used to persist the VPN server configurations. The `ports` parameter maps the UDP port 51820 of the container to the same port in the host system, which is the default port used by the WireGuard protocol.

The `sysctls` parameter sets a Linux kernel parameter for the container that allows for setting the `src_valid_mark` flag on outgoing packets, which is required for the WireGuard protocol to work correctly.

Finally, the `restart` parameter specifies that the container should always restart unless stopped manually.

To run this file, save it to a file called `docker-compose.yml`, navigate to the directory containing the file, and run `docker-compose up`. The containers will be created, and the WireGuard VPN server will be started.

![Wireguard](https://www.wireguard.com/img/wireguard.svg)
