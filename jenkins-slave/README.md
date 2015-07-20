# Jenkins Slave of Docker controller

An image to control Docker host from Jenkins slave.

This image has following features:

* SSH server - `sshd` is running on a container
* Docker client - `docker` command is available
* Docker Compose - `docker-compose` command is available


## How to Use

Run a container of the image.

```sh
docker build -t slave .
docker run -d -e ssh_passwd=qazwsx -p 8022:22 slave
```

Add a slave on Jenkins.

Item        | Value
------------|------
Slave Name  | docker
IP Address  | (IP Address of the Docker host)
Port        | 8022
Username    | `jenkins`
Password    | `qazwsx`

