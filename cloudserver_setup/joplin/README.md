## Joplin: docker-compose deployment

This Docker Compose file is used to deploy Joplin Server, a free and open-source note-taking and to-do application. The Compose file defines two services, `db` and `app`.

The `db` service is based on the official Postgres Docker image version 13. It defines a volume to persist the Postgres database data in the local path `/local/path/to/mount/joplin`. The `ports` section maps the internal Postgres port 5432 to the same port on the host machine. The `environment` section sets the database name, user, and password for the Postgres container.

The `app` service is based on the latest version of the Joplin Server Docker image. It depends on the `db` service and maps the internal Joplin Server port 22300 to the same port on the host machine. The `restart` section ensures the container restarts unless stopped. The `healthcheck` section checks the Joplin Server health by sending an HTTP request to `http://localhost:3000` every 30 seconds. The `environment` section sets Joplin Server port, base URL, and Postgres database parameters.

To run this Docker Compose file, you need to first save it as a `docker-compose.yml` file in a local directory. Then navigate to the directory in a terminal and run the command `docker-compose up -d` to start the containers in the background. The option `-d` runs the containers in detached mode. You can use `docker-compose logs -f` to see the logs of the containers, and `docker-compose down` to stop the containers.

![joplin](https://joplinapp.org/images/home-top-img-2x.webp)