## How to setup Wireguard on Raspberry Pi


This guide will walk you through the process of setting up a WireGuard VPN on your Raspberry Pi 3 B using Docker. By the end of this guide, you will be able to securely connect to your Raspberry Pi from anywhere in the world, as long as you have an internet connection and port 51820 is open and forwarded to your Raspberry Pi's local IP address.

Before you begin setting up your WireGuard VPN on your Raspberry Pi 3, ensure that you have the following:

- A micro SD card with at least 8GB of storage capacity.
- A Raspberry Pi 3 board with the latest version of Raspbian OS installed.
- An active internet connection with a public IP address.
- Port 51820 open on your router and forwarded to the local IP address of your Raspberry Pi 3. You may need to refer to your router's documentation to learn how to forward ports.

### Downloading Raspbian OS:

To download Raspbian OS, we recommend using the Raspberry Pi Imager tool, which is a quick and easy way to install the operating system onto a microSD card. To get started, head over to the  [Raspbian OS download page](https://www.raspberrypi.com/software/) and download the Raspberry Pi Imager for your operating system (Linux, Mac, or Windows).

### Installing Raspbian OS:

Once you have downloaded the Raspberry Pi Imager utility, insert the microSD card into your computer and launch the Raspberry Pi Imager application. You'll be presented with several options to choose from. For this guide, we recommend selecting "Raspberry Pi OS (Other)" as the operating system, and then choosing "Raspberry Pi OS Lite (64-bit)" without a desktop environment. This is because we'll be setting up the Raspberry Pi as a headless server, but you can choose to install the desktop version if you prefer.

Next select the appropriate options, you'll be prompted to select the storage device where you want to install Raspbian OS. Be sure to choose the correct device, which should be the microSD card.

Before writing the Raspbian OS image to the microSD card, click on the gear icon below the "Write" button. This will bring up a settings menu where you can configure additional options, including setting up a username and password for your Raspberry Pi.

Create a username and password that you will use to login to the Raspbian OS later. This will be important for future steps in the guide, so be sure to remember the username and password you choose. Once you have set up the username and password, click on "OK" to save your settings.

Once you have confirmed the storage device, click on the "Write" button and the process of writing the Raspbian OS image to the microSD card will begin. This process may take several minutes to complete, depending on the speed of your microSD card and your computer. Once the process is complete, safely eject the microSD card from your computer and insert it into your Raspberry Pi 3.

### Enabling SSH:

By default, SSH (Secure Shell) is disabled on Raspbian OS. However, since we installed the headless server version, it's recommended to enable SSH so that you can easily access the Raspberry Pi device from another computer without having to type long commands into the Pi console.

To enable SSH, first login to the Raspbian OS console with the username and password you created earlier. Then, open the terminal and run the following command to launch the raspi-config utility:

```
sudo raspi-config
```

In the configuration tool, select option 3 "Interface Options" and then choose "SSH" to enable SSH. Once you have enabled SSH, exit the configuration tool. SSH is now enabled on your Raspberry Pi, and you can access it from another machine using an SSH client.

### Installing Docker:

Before installing Docker, ensure that your Raspbian OS is up to date with the latest dependencies.

Update the system with the following command:

```
sudo apt update && sudo apt upgrade -y && sudo apt autoclean -y
```

To install Docker on Raspberry Pi, use the following command:

This script will detect your system and architecture and install Docker for you.

```
curl -sSL https://get.docker.com | sh
```

### Granting non-root users access to Docker:

By default, Docker requires root privileges to run. To allow non-root users to use Docker, you can add your user to the `docker` group.

Use the following command to add the current user to the `docker` group:

```
sudo usermod -aG docker $USER
```

Remember to log out and log back in for the changes to take effect. If that does not work then reboot the device.

Finally, start the Docker daemon with the following command:

```
sudo service docker start
```

This should enable you to run Docker commands without encountering the "Cannot connect to the Docker daemon" error.

### Deploying Wireguard:

To deploy Wireguard, you can use a preconfigured docker-compose file which can be found on my GitHub page [Wireguard docker-compose](https://github.com/sohaib1khan/home_server_setup/blob/main/cloudserver_setup/wireguard/docker-compose.yaml) or you can find it below.

To keep things organized, create a separate directory called "wireguard," move into that new directory, and then create a new file called `docker-compose.yaml`. Inside that file, copy and paste the following content:

```
---
version: "2.1"
services:
  wireguard:
    image: lscr.io/linuxserver/wireguard
    container_name: wireguard-1
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=United States/New York
      - SERVERURL=auto #optional
      - SERVERPORT=51820 #optional
      - PEERS=3 #optional
      - PEERDNS=auto #optional
      - INTERNAL_SUBNET=10.11.11.0 #optional
      - ALLOWEDIPS=0.0.0.0/0 #optional
    volumes:
      - local/path/to/mount/wireguard:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped
```

Save and exit the file.

To deploy the WireGuard application, run the following command:

```
docker-compose up -d
```

To obtain the keys, execute the following command to enter the container:

```
docker exec -it wireguard-1 bash
```

Once inside the container, navigate to the config directory to access the WireGuard configuration files:

```
cd /config/
```

The config directory will contain all the information you need for WireGuard, including the keys.

### Barcode View:

If you want to set up WireGuard on your mobile device using the barcode, run the following command from your host to retrieve the necessary information from the container:

```
docker exec -it wireguard-1 /app/show-peer <peer-number>
```

For example, to retrieve information for peer1, run:

```
docker exec -it wireguard-1 /app/show-peer 1
```