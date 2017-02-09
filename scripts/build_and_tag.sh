#/bin/bash

BUILD_HASH="$(docker build -q .)"

docker tag $BUILD_HASH mattjc/development_environment:latest
