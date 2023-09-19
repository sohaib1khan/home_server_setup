This script is designed to monitor the health of your Raspberry Pi, including its CPU and Memory usage, and the status of Docker containers. Once it gathers this data, it sends an alert with the details to a Gotify server.

## Pre-requisites

### Installing Glances

Before you can run the script, you need to have Glances installed on your Raspberry Pi. Glances is a cross-platform monitoring tool written in Python.

> You will need to have pub/sub service setup. I'm using gotify for this.

#### Option 1: Glances Auto Install Script

This method is supported only on some GNU/Linux distributions.

```
curl -L https://bit.ly/glances | /bin/bash
```

Or

```
$ wget -O- https://bit.ly/glances | /bin/bash
```

For more details, you can check out the official Glances documentation [here](https://nicolargo.github.io/glances/?ref=itsfoss.com).

#### Option 2: Install via PyPI

You can also install Glances using pip. This ensures that you get the latest stable version of Glances.

```
$ pip install glances
```

## Script Usage

Once Glances is installed, you can use the following script to monitor your Raspberry Pi's health:

```
#!/bin/bash

# Fetch CPU Usage using Glances
CPU_USAGE=$(timeout 2 /usr/local/bin/glances --stdout cpu.user | grep "cpu.user" | cut -d: -f2 | tr -d ' ')

# Fetch Memory Usage in a human-readable format
MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.2f", $3/$2 * 100.0}')

# Check Docker Container Health
CONTAINER_STATUS=$(sudo docker ps --format "{{.Names}} - {{.Status}}")

# Send the alert with the gathered data
MESSAGE="Current CPU Usage: $CPU_USAGE% and Memory Usage: $MEMORY_USAGE%. Docker Containers: $CONTAINER_STATUS"
curl "https://URL_TO_GOTIFY/message?token=YOUR_TOKEN" -F "title=Raspberry Pi Alert" -F "message=$MESSAGE" -F "priority=10"
```

To run the script, you can save it as `rasp_alert.sh`, give it executable permissions using `chmod +x rasp_alert.sh`, and then execute it with `./rasp_alert.sh`
