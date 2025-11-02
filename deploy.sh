#!/bin/bash
set -e

DEPLOY_HOST=$1
IMAGE_URI=$2
CONTAINER_NAME=vite-react-app
PORT=80

ssh -o StrictHostKeyChecking=no $DEPLOY_HOST <<EOF
  docker stop $CONTAINER_NAME || true
  docker rm $CONTAINER_NAME || true
  docker pull $IMAGE_URI
  docker run -d --name $CONTAINER_NAME -p $PORT:80 --restart unless-stopped $IMAGE_URI
  docker ps --filter name=$CONTAINER_NAME
EOF
