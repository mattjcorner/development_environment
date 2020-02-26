#!/bin/bash

export HOSTNAME=mattdev

docker run -ti \
-v "/var/run/docker.sock:/var/run/docker.sock" \
-v "/${HOME}/Projects:/root/Projects" \
-v "/${HOME}/.ssh:/root/.ssh" \
-v "/${HOME}/.gitconfig:/root/.gitconfig" \
-v "/${HOME}/.aws:/root/.aws":ro \
-v "/${HOME}/Downloads:/root/Downloads" \
-p 80:80 \
-p 8080:8080 \
--hostname "$HOSTNAME" \
--net=host \
mattjc/development_environment:latest //bin/bash

