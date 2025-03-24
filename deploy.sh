#!/bin/bash

# Exit on any error
set -e

# Config
NAMESPACE="k8s-nodejs-nextjs"

echo "Deploying to Kubernetes..."

# Create namespace if it doesn't exist
kubectl apply -f k8s/namespace.yaml

# Set the namespace for subsequent commands
KUBECTL="kubectl --namespace=$NAMESPACE"

# Apply the Kubernetes configurations
echo "Applying Kubernetes configurations..."
$KUBECTL apply -f k8s/backend-deployment.yaml
$KUBECTL apply -f k8s/backend-service.yaml
$KUBECTL apply -f k8s/frontend-deployment.yaml
$KUBECTL apply -f k8s/frontend-service.yaml

echo "Deployment completed!"
echo "You can check the status with:"
echo "  kubectl get pods -n $NAMESPACE"
echo "  kubectl get services -n $NAMESPACE"

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
$KUBECTL rollout status deployment/backend-deployment
$KUBECTL rollout status deployment/frontend-deployment

echo "Services information:"
$KUBECTL get services

# For Minikube
if command -v minikube &> /dev/null; then
  echo "To access the application via minikube, run:"
  echo "  minikube service frontend-service -n $NAMESPACE"
fi

echo "Deployment complete!"
