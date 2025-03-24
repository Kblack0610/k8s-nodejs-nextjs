#!/bin/bash

# Exit on any error
set -e

echo "Setting up Minikube Kubernetes cluster..."

# Check if Minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "Minikube not found. Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
fi

# Check if kubectl is available (we downloaded it earlier)
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found in PATH. Using the one we downloaded."
    # The kubectl binary should be in the current directory
    if [ -f "./kubectl" ]; then
        chmod +x ./kubectl
        export PATH=$PATH:$(pwd)
    else
        echo "Error: kubectl not found. Please install kubectl."
        exit 1
    fi
fi

# Start Minikube
echo "Starting Minikube..."
minikube start

# Configure Docker to use Minikube's Docker daemon
echo "Configuring Docker to use Minikube's Docker daemon..."
echo "Run the following command in your terminal to configure Docker:"
echo 'eval $(minikube docker-env)'
echo "You'll need to run this command in each new terminal session."

# Check if Minikube is running
echo "Checking Minikube status..."
minikube status

echo "Minikube setup complete!"
echo "Now you can build and deploy your application using:"
echo "  ./build-images.sh"
echo "  ./deploy.sh"
