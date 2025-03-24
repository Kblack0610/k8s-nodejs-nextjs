#!/bin/bash

# Exit on any error
set -e

# Config
BACKEND_IMAGE="backend:latest"
FRONTEND_IMAGE="frontend:latest"

echo "Building and importing Docker images for k3s..."

# Build backend image
echo "Building backend image..."
cd backend
docker build -t $BACKEND_IMAGE .
echo "Saving backend image to tarball..."
docker save $BACKEND_IMAGE > ../backend-image.tar
cd ..

# Build frontend image
echo "Building frontend image..."
cd frontend
docker build -t $FRONTEND_IMAGE .
echo "Saving frontend image to tarball..."
docker save $FRONTEND_IMAGE > ../frontend-image.tar
cd ..

# Import images into k3s containerd
echo "Importing images into k3s containerd..."
sudo k3s ctr images import backend-image.tar
sudo k3s ctr images import frontend-image.tar

# Clean up tarballs to save space
echo "Cleaning up image tarballs..."
rm backend-image.tar frontend-image.tar

echo "Verifying imported images in k3s..."
sudo k3s ctr images ls | grep -E 'backend|frontend'

echo "Docker images built and imported into k3s successfully!"
