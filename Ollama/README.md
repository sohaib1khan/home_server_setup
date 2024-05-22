This Docker Compose configuration sets up two services:

1.  **ollama**: A service for running the Ollama model server.
2.  **open-webui**: A web interface for interacting with the Ollama model server.

This setup supports both AMD and NVIDIA GPUs. Depending on your GPU, you'll need to install the appropriate drivers and tools (ROCm for AMD or CUDA for NVIDIA).

### Prerequisites

#### General Requirements

- Docker and Docker Compose installed on your machine.
- GPU drivers installed (either ROCm for AMD or CUDA for NVIDIA).

#### AMD GPU

1.  Install ROCm (Radeon Open Compute).
    - Follow the ROCm installation guide for your specific Linux distribution.
2.  Ensure the `amdgpu` driver is installed and loaded.

#### NVIDIA GPU

1.  Install NVIDIA drivers and CUDA toolkit.
    - Follow the [CUDA installation guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) for your specific Linux distribution.
2.  Install the NVIDIA Container Toolkit.

```
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

&nbsp;

### Docker Compose Configuration

#### File: `docker-compose.yaml`

```
version: '3.8'

services:
  ollama:
    image: ollama/ollama:${OLLAMA_DOCKER_TAG-latest}
    container_name: ollama
    volumes:
      - $PWD/ollama:/root/.ollama
    devices:
      # Uncomment the appropriate lines depending on your GPU
      - /dev/kfd:/dev/kfd         # For AMD GPUs
      - /dev/dri:/dev/dri         # For AMD GPUs
      #- /dev/nvidia0:/dev/nvidia0  # For NVIDIA GPUs
      #- /dev/nvidiactl:/dev/nvidiactl  # For NVIDIA GPUs
      #- /dev/nvidia-uvm:/dev/nvidia-uvm  # For NVIDIA GPUs
      #- /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools  # For NVIDIA GPUs
    environment:
      # Uncomment the appropriate line depending on your GPU
      - HSA_OVERRIDE_GFX_VERSION=${HSA_OVERRIDE_GFX_VERSION-11.0.0}  # For AMD GPUs
      #- NVIDIA_VISIBLE_DEVICES=all  # For NVIDIA GPUs
      #- NVIDIA_DRIVER_CAPABILITIES=compute,utility  # For NVIDIA GPUs
    tty: true
    restart: unless-stopped
    pull_policy: always

  open-webui:
    build:
      context: .
      args:
        OLLAMA_BASE_URL: '/ollama'
      dockerfile: Dockerfile
    image: ghcr.io/open-webui/open-webui:${WEBUI_DOCKER_TAG-main}
    container_name: open-webui
    volumes:
      - $PWD/open-webui:/app/backend/data
    depends_on:
      - ollama
    ports:
      - ${OPEN_WEBUI_PORT-3000}:8080
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
      - WEBUI_SECRET_KEY
    extra_hosts:
      - host.docker.internal:host-gateway
    restart: unless-stopped

volumes:
  ollama: {}
  open-webui: {}
```

&nbsp;

### Usage

1.  **Clone the Repository**:

```
git clone https://github.com/your-repo/ollama-webui.git
cd ollama-webui
```

2. **Configure Environment Variables**: Create a `.env` file in the root directory of your project and set the necessary environment variables. Example:

```
OLLAMA_DOCKER_TAG=latest
WEBUI_DOCKER_TAG=main
OPEN_WEBUI_PORT=3000
HSA_OVERRIDE_GFX_VERSION=11.0.0  # For AMD GPUs
# NVIDIA_VISIBLE_DEVICES=all  # For NVIDIA GPUs
# NVIDIA_DRIVER_CAPABILITIES=compute,utility  # For NVIDIA GPUs
```

3. **Build and Run**:

```
docker-compose up -d
```

4. **Access the Web UI**: Open your web browser and navigate to `http://localhost:3000` (or the port you specified).

### Troubleshooting

- **GPU Utilization**:
    
    - Verify if your GPU is being utilized correctly by checking the logs.

```
docker logs ollama
```

- - Ensure that the correct drivers and tools are installed and configured properly.
- **Port Conflicts**:
    
    - Ensure no other services are using the ports specified in the `docker-compose.yml` file.

### Switching Between AMD and NVIDIA GPUs

- **For AMD GPUs**:
    
    - Ensure ROCm is installed.
    - Uncomment the `devices` and `environment` lines related to AMD in the `docker-compose.yml` file.
    - Comment out any NVIDIA-specific lines.
- **For NVIDIA GPUs**:
    
    - Ensure CUDA and NVIDIA drivers are installed.
    - Uncomment the `devices` and `environment` lines related to NVIDIA in the `docker-compose.yml` file.
    - Comment out any AMD-specific lines.

By following these instructions, you should be able to set up and run the Ollama model server and its web UI, leveraging either an AMD or NVIDIA GPU as needed.