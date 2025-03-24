#!/bin/bash

# Exit on any error
set -e

echo "Setting up k3s lightweight Kubernetes cluster..."

# Check if k3s is installed
if ! command -v k3s &> /dev/null; then
    echo "k3s not found. Installing k3s..."
    curl -sfL https://get.k3s.io | sh -
    # Wait for k3s to become available
    echo "Waiting for k3s to start..."
    sleep 10
    # Set up the kubeconfig file
    mkdir -p ~/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
    sudo chown $(id -u):$(id -g) ~/.kube/config
    export KUBECONFIG=~/.kube/config
fi

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found in PATH. Using the one installed with k3s."
    # k3s ships with kubectl, so we should be able to use it
    if [ -f "/usr/local/bin/kubectl" ]; then
        echo "Using k3s kubectl"
    else
        echo "Error: kubectl not found. Installing kubectl..."
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
    fi
fi

# Check if k3s is running
echo "Checking k3s status..."
sudo systemctl status k3s --no-pager || {
    echo "Starting k3s service..."
    sudo systemctl start k3s
}

# Configure kubectl to use k3s context
echo "Configuring kubectl to use k3s context..."
export KUBECONFIG=~/.kube/config
kubectl config use-context default

# Check k3s node status
echo "Checking k3s node status..."
kubectl get nodes

# Configure container runtime for building images
echo "Setting up container runtime for k3s..."
echo "k3s uses containerd as its container runtime."
echo "To build and use local images with k3s, you can:"
echo "1. Use a local registry (recommended for production)"
echo "2. Import images directly into containerd"

# Instructions for option 2 - importing images into containerd
echo ""
echo "To import Docker images directly into k3s containerd:"
echo "1. Build your image with Docker: docker build -t myimage:tag ."
echo "2. Save the image to a tarball: docker save myimage:tag > myimage.tar"
echo "3. Import into k3s: sudo k3s ctr images import myimage.tar"
echo ""
echo "This project's build-k3s-images.sh script automates this process."

echo "k3s setup complete!"
echo "Now you can build and deploy your application using:"
echo "  ./build-k3s-images.sh"
echo "  ./deploy.sh"
