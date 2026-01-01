#!/usr/bin/env bash
set -e

APP_NAME="gateway"
CONTAINER_NAME="gateway"
PORT_MAPPING="8080:80"
ENV_FILE=".env"

echo "▶ Fetching latest code..."
git fetch origin
git pull origin main

echo "▶ Getting git commit hash..."
COMMIT_HASH=$(git rev-parse --short HEAD)

IMAGE_TAG="${APP_NAME}:${COMMIT_HASH}"

echo "▶ Building image: $IMAGE_TAG"
podman build -t "$IMAGE_TAG" .

echo "▶ Stopping old container (if exists)..."
podman stop "$CONTAINER_NAME" 2>/dev/null || true
podman rm "$CONTAINER_NAME" 2>/dev/null || true

echo "▶ Running new container..."
podman run -d --name "$CONTAINER_NAME" --restart=always --env-file "$ENV_FILE" -p $PORT_MAPPING "$IMAGE_TAG"

echo "▶ Cleaning old images..."
podman image prune -f

echo "✅ Deployment successful: $IMAGE_TAG"
