# Kubernetes Node.js & Next.js Template

This repository provides a production-ready template for deploying a Node.js backend and Next.js frontend application to Kubernetes. It includes all the necessary configuration files, Dockerfiles, and deployment scripts.

## Project Structure

```
k8s-nodejs-nextjs/
├── backend/            # Node.js Express backend
│   ├── Dockerfile      # Backend container definition
│   ├── index.js        # Main backend server code
│   └── package.json    # Backend dependencies
├── frontend/           # Next.js frontend application
│   ├── Dockerfile      # Frontend container definition
│   ├── next.config.js  # Next.js configuration with API proxying
│   ├── package.json    # Frontend dependencies
│   ├── tsconfig.json   # TypeScript configuration
│   └── src/            # Frontend source code
│       └── app/        # Next.js app directory
├── k8s/                # Kubernetes configuration files
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   └── namespace.yaml
├── build-images.sh     # Script to build Docker images for Minikube
├── build-k3s-images.sh # Script to build Docker images for k3s
├── deploy.sh           # Script to deploy to Kubernetes
├── setup-minikube.sh   # Script to set up Minikube
└── setup-k3s.sh        # Script to set up k3s
```

## Architecture

This template follows best practices for modern web application deployment:

- **Decoupled Frontend/Backend**: Separate services that can be scaled independently
- **API Proxying**: Next.js configured to proxy API requests to the backend service
- **Containerization**: Docker images for consistent deployment
- **Kubernetes Native**: Designed to run on any Kubernetes cluster
- **Multiple Cluster Options**: Support for both Minikube and k3s

## Prerequisites

- Docker
- Kubernetes cluster (Minikube, k3s, or cloud-based Kubernetes)
- kubectl
- Node.js and npm (for local development)

## Getting Started

### 1. Using This Template

To use this template for your own project:

1. Clone this repository
2. Replace the example backend and frontend code with your application code
3. Update the Kubernetes resource names if desired
4. Follow the deployment instructions below

### 2. Local Development

To run the applications locally for development:

**Backend:**
```bash
cd backend
npm install
npm start
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
```

The backend will be available at http://localhost:5000 and the frontend at http://localhost:3000.

### 3. Setting Up Kubernetes

#### Option A: Minikube

To set up a Minikube cluster:

```bash
./setup-minikube.sh
```

This will:
1. Install Minikube if not already installed
2. Start the Minikube cluster
3. Configure Docker to use Minikube's Docker daemon

#### Option B: k3s (Lightweight Kubernetes)

To set up a k3s cluster:

```bash
./setup-k3s.sh
```

This will:
1. Install k3s if not already installed
2. Start the k3s service
3. Configure kubectl to use the k3s context
4. Provide instructions for working with k3s's containerd

### 4. Building Docker Images

#### For Minikube:

```bash
./build-images.sh
```

#### For k3s:

```bash
./build-k3s-images.sh
```

The k3s build script handles the extra step of importing the images into k3s's containerd runtime.

### 5. Deploying to Kubernetes

Deploy the application to Kubernetes:

```bash
./deploy.sh
```

This will:
1. Create a dedicated namespace
2. Deploy the backend and frontend services
3. Create appropriate Kubernetes services for communication

### 6. Accessing the Application

To access the application:

**Minikube:**
```bash
minikube service frontend-service -n k8s-nodejs-nextjs
```

**k3s:**
```bash
# Get the NodePort of the frontend service
kubectl get svc frontend-service -n k8s-nodejs-nextjs

# Access using your machine's IP and the NodePort
# Example: http://192.168.1.100:30123
```

**Other Kubernetes setups:**
Get the external IP of the frontend service:
```bash
kubectl get services -n k8s-nodejs-nextjs
```

## Customizing the Template

### Changing Application Names

1. Update the namespace name in `k8s/namespace.yaml`
2. Update references to this namespace in deployment files and scripts
3. Modify service and deployment names as needed

### Adjusting Resource Limits

Resource limits for CPU and memory can be adjusted in:
- `k8s/backend-deployment.yaml`
- `k8s/frontend-deployment.yaml`

### Adding Environment Variables

Add environment variables to:
- `k8s/backend-deployment.yaml` for backend variables
- `k8s/frontend-deployment.yaml` for frontend variables

## Troubleshooting

- **Check pod status:** `kubectl get pods -n k8s-nodejs-nextjs`
- **View pod logs:** `kubectl logs [pod-name] -n k8s-nodejs-nextjs`
- **Pod shell access:** `kubectl exec -it [pod-name] -n k8s-nodejs-nextjs -- /bin/sh`
- **Image issues:** Make sure Docker is configured to use Minikube's Docker daemon (`eval $(minikube docker-env)`) before building images

## License

This project is licensed under the MIT License.
