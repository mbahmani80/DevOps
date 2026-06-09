👉 DOCKER CHEAT SHEET
===================================================================================================

1. CORE CONCEPT
===================================================================================================

Docker packages applications together with all required dependencies
(code, runtime, libraries, and configuration) into containers.

Problem:
  "It works on my machine"
  Environment inconsistencies between development, testing, and production.

Solution:
  Build once, run anywhere.
  Benefits:
    - Consistency
    - Portability
    - Easy deployment
    - Simplified scaling

Architecture:
  Docker CLI <-> Docker Daemon <-> Registry

    CLI      : User commands
    Daemon   : Manages containers/images
    Registry : Stores container images
#===================================================================================================

2. QUICK INSTALLATION REFERENCE
===================================================================================================

# Ubuntu:
$ sudo apt update
$ sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update
$ sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Debian:
$ sudo apt update
$ sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
$ echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt update
$ sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Rocky Linux:
$ sudo dnf update -y
$ sudo dnf install -y yum-utils device-mapper-persistent-data lvm2
$ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


POST-INSTALLATION
=================
  sudo systemctl enable --now docker
  sudo systemctl status docker

Allow current user to run Docker without sudo:
  sudo usermod -aG docker $USER

Important:
  Log out and log back in for the group change to take effect.
#===================================================================================================

3. KEY CONCEPTS
===================================================================================================

CONTAINER LIFECYCLE
-------------------

docker run
  Creates and starts a container in a single step.

docker create
  Creates a container without starting it.
  Useful when configuration must be completed before startup.
docker start
  Starts a previously created or stopped container.
# Example:
# Create the container, naming it 'my-web'
docker create --name my-web -p 8080:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html:ro nginx:alpine
# Create a custom welcome page
echo "<h1>Hello! This is my custom config.</h1>" > index.html
# Starts created container
docker start my-web



EXEC VS ATTACH
--------------

Preferred:
  docker exec -it <container> bash

Why use exec?
  - Starts a new process inside the container
  - Multiple sessions allowed
  - Safer for production systems
  - Does not affect the main application process

Example:
  docker exec -it my_container bash

docker attach
  #Connects directly to the container's primary process (PID 1).

Risks:
  - Ctrl+C may stop the main application
  - Can accidentally terminate the container

Detach safely:
  Ctrl+P
  Ctrl+Q
#===================================================================================================



4. ESSENTIAL COMMANDS
===================================================================================================

IMAGE MANAGEMENT
----------------

Pull image:
  docker pull <image>

List local images:
  docker images

Remove image:
  docker rmi <image_id>

Export image:
  docker save

Import image:
  docker load

Option 1: Save the original Alpine image
docker save -o alpine_myversion.tar alpine
or
docker save alpine > alpine_myversion.tar

Option 2: Save the current state of the running container
docker commit xenodochial_joliot alpine_myversion
docker images
docker save -o alpine_myversion.tar alpine_myversion
gzip alpine_myversion.tar
docker images


CONTAINER LIFECYCLE
-------------------

Create and start container:
  docker run <image>

Create container only:
  docker create <image>

Start container:
  docker start <container>

Stop container:
  docker stop <container>

Restart container:
  docker restart <container>

Remove container:
  docker rm <container>


DEBUGGING AND INSPECTION
------------------------

List running containers:
  docker ps

List all containers:
  docker ps -a

View logs:
  docker logs <container>

Execute command inside container:
  docker exec <container> <command>

Inspect container details:
  docker inspect <container>
#===================================================================================================


5. ADVANCED OPERATIONAL TIPS
===================================================================================================

CPU RESOURCE MANAGEMENT
-----------------------

Restrict container to CPU core 0:
  docker run --cpuset-cpus=0 <image>

Move running container to CPU core 1:
  docker update <container_id> --cpuset-cpus=1


CLEANUP COMMANDS
----------------

Remove stopped containers, unused networks,
and dangling images:
  docker system prune

Remove all stopped containers:
  docker container prune

Remove all unused images:
  docker image prune -a


BULK CONTAINER REMOVAL
----------------------

Force remove all containers:
  docker rm -f $(docker ps -aq)

Remove only exited containers:
  docker rm $(docker ps -aq -f status=exited)
#===================================================================================================


6. MOST COMMON COMMANDS
===================================================================================================

docker pull <image>
docker run <image>
docker ps
docker logs <container>
docker exec -it <container> bash
docker stop <container>
docker rm <container>
docker images
docker rmi <image>
docker system prune

