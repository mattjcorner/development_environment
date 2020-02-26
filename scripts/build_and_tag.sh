#/bin/bash

BUILD_HASH="$(docker build -q .)"

if [[ ! -z "$BUILD_HASH" ]]; then
	docker tag $BUILD_HASH mattjc/development_environment:latest
fi
