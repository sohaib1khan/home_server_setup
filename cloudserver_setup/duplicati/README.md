## Duplicati: docker-compose deployment

This is a Docker Compose file for deploying an instance of Duplicati, a free backup software, using the LinuxServer.io image.

Here is a breakdown of the file:

- `version`: Specifies the version of the Docker Compose syntax to use.
    
- `services`: Defines the services that will be run.
    
    - `duplicati`: The name of the service.
        
        - `image`: The Docker image to use for the service.
        - `container_name`: The name to give to the container when it is started.
        - `environment`: A list of environment variables to set when the container is started.
        - `volumes`: A list of volumes to mount into the container. These are directories on the host machine that will be accessible from within the container.
        - `ports`: A list of port mappings to expose from the container to the host machine.
        - `restart`: Specifies the restart policy for the container.

In this case, the Duplicati service is set up to use the latest LinuxServer.io Duplicati image. The container will be named "duplicati" and will run with the PUID and PGID set to 1000. The timezone is set to "United States/New York". The optional `CLI_ARGS` environment variable can be used to pass additional arguments to Duplicati. The volumes will be mounted at `/config`, `/backups`, and `/source` respectively. Port 8200 will be mapped to the host machine. Finally, the `unless-stopped` restart policy means that the container will be restarted unless it is explicitly stopped.


![Duplicati](https://www.duplicati.com/images/duplicati-fb-share-v1.png)
