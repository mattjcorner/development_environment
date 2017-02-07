#/bin/bash

BUILD_HASH="$(docker build -q .)"

docker tag $BUILD_HASH mattjc/linux_dev_environment:latest
docker push mattjc/linux_dev_environment:latest
