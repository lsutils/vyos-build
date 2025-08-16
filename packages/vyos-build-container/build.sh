#!/bin/sh
set -e

cd vyos-build/docker

#echo "Inspecting current image of ${BRANCH_NAME}..."
#previousImageId=$(docker images --filter=reference="vyos/vyos-build:${BRANCH_NAME}" --format "{{.ID}}")
#
#echo "Building docker build container for branch ${BRANCH_NAME}..."
#docker build --no-cache -t "vyos/vyos-build:${BRANCH_NAME}" --build-arg ARCH=arm64v8/  .
#
docker pull registry.cn-hangzhou.aliyuncs.com/ls-2018/vyos-build:sagitta-arm64-dd010101

#echo "Pushing ${BRANCH_NAME} image to registry ${CUSTOM_DOCKER_REPO}..."
docker tag registry.cn-hangzhou.aliyuncs.com/ls-2018/vyos-build:sagitta-arm64-dd010101 "${CUSTOM_DOCKER_REPO}/vyos/vyos-build:${BRANCH_NAME}-arm64"
docker tag registry.cn-hangzhou.aliyuncs.com/ls-2018/vyos-build:sagitta-arm64-dd010101 "${CUSTOM_DOCKER_REPO}/vyos/vyos-build:${BRANCH_NAME}"
docker push "${CUSTOM_DOCKER_REPO}/vyos/vyos-build:$BRANCH_NAME"
docker push "${CUSTOM_DOCKER_REPO}/vyos/vyos-build:$BRANCH_NAME-arm64"
#
#echo "Cleaning previous image of ${BRANCH_NAME}..."
#if [ "$previousImageId" != "" ]; then
#  docker rmi --force "$previousImageId" || true
#fi
docker rmi registry.cn-hangzhou.aliyuncs.com/ls-2018/vyos-build:sagitta-arm64-dd010101

echo "Cleaning local registry..."
docker exec registry registry garbage-collect /etc/docker/registry/config.yml --delete-untagged=true

echo "Image ${BRANCH_NAME} was successfully built and pushed to registry ${CUSTOM_DOCKER_REPO}."
