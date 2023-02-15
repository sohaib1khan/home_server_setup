## Nextcloud: docker-compose deployment

This Docker Compose file deploys a Nextcloud instance with a MariaDB database using Docker. It defines two volumes named "nextcloud" and "db" for storing the Nextcloud app and MariaDB database data, respectively.

The "services" section of the file defines two services: "db" and "app". The "db" service uses the "mariadb:10.5" image and sets environment variables for configuring the database, including the root password, user, database name, and password. It also mounts the "db" volume to persist the database data.

The "app" service uses the "nextcloud" image and exposes port 8080 to the host machine. It links to the "db" service to communicate with the database and mounts the "nextcloud" volume to persist Nextcloud data. The service also sets environment variables to configure the database connection.

Additionally, an ".env" file contains the environment variables for the deployment.

To deploy this configuration, navigate to the directory where the Compose file and ".env" file are located and run the command "docker-compose up". Docker Compose will create and start the containers defined in the file, using the configuration and environment variables specified in the Compose and ".env" files.

docker-compose.yaml

```
version: '2'

volumes:
  nextcloud:
  db:

services:
  db:
    image: mariadb:10.5
    restart: always
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud

  app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    links:
      - db
    volumes:
      - /path/to/where/you/want/to/mount:/var/www/html
    environment:
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=db
```

The .env file should look something like this. 

```
MYSQL_ROOT_PASSWORD=SOMESECRETPASSWORD
MYSQL_PASSWORD=SOMESECRETPASSWORD
```