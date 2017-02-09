#!/bin/bash

export HOSTNAME=mattdev

docker run -ti -e "DOCKER_HOST=tcp://0.0.0.0:2375" \
-v "/${HOME}/Projects:/root/Projects" \
-v "/${HOME}/.ssh:/root/.ssh" \
-v "/${HOME}/.gitconfig:/root/.gitconfig" \
-v "/${HOME}/.aws:/root/.aws":ro \
-v "/${HOME}/Downloads:/root/Downloads
--hostname "$HOSTNAME" \
mattjc/linux_dev_environment:latest //bin/bash

