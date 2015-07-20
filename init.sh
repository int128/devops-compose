#!/bin/sh
sudo yum update -y
sudo yum install -y docker
sudo curl -L -o /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m`
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker "$USER"
docker -v
docker-compose -v
