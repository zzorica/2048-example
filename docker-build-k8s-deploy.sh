#!/bin/bash

# Step 1: Check if Kind is installed
if ! command -v kind &>/dev/null; then
    echo "Kind not found. Installing Kind..."
    # Install Kind (requires Homebrew to be installed)
    brew install kind
    if [ $? -ne 0 ]; then
        echo "Failed to install Kind. Exiting."
        exit 1
    fi
else
    echo "Kind is already installed."
fi

# Step 2: Check if Docker is running
if ! docker info &>/dev/null; then
    echo "Docker is not running. Please start Docker and rerun the script."
    exit 1
fi

# Step 3: Check if a Kind cluster exists
if ! kind get clusters | grep -q "2048"; then
    echo "No Kind cluster found. Creating a new Kind cluster..."
    kind create cluster --name 2048
else
    echo "Kind cluster already exists."
fi

# # Step 4: Build the Docker image for the 2048 game
echo "Building the 2048 Docker image..."
docker build -t 2048-game:latest .

# # Step 5: Load the image into the Kind cluster
echo "Loading the Docker image into the Kind cluster..."
kind load docker-image 2048-game:latest --name 2048

# Step 6: Deploy the application to the Kubernetes cluster
echo "Deploying the 2048 game to Kubernetes..."
kubectl apply -f k8s-deployment.yaml

# Step 7: Wait for the deployment to complete
echo "Waiting for the 2048 game to be deployed..."
kubectl rollout status deployment/game-2048

# Step 8: Port-forward to access the game on localhost
echo "Port-forwarding to access the 2048 game at http://localhost:8080..."
kubectl port-forward svc/game-2048 8080:80
