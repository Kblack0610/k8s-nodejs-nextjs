#!/bin/bash

# Exit on any error
set -e

# Config
BACKEND_IMAGE="backend:latest"
FRONTEND_IMAGE="frontend:latest"

echo "Building Docker images..."

# Build backend image
echo "Building backend image..."
cd backend
docker build -t $BACKEND_IMAGE .
cd ..

# Build frontend image
echo "Building frontend image..."
cd frontend
docker build -t $FRONTEND_IMAGE .
cd ..

echo "Docker images built successfully!"

# If using a local registry with Kubernetes (like Minikube), you would need
# additional steps to make the images available to the cluster
# For Minikube, you'd typically run:
# eval $(minikube docker-env)
# And rebuild the images for them to be available to Minikube

echo "Done!"
