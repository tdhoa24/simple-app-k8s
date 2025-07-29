#!/bin/bash

echo "🟢 Deploying microservices to MicroK8s..."

microk8s kubectl apply -f postgres.yaml
microk8s kubectl apply -f user-service.yaml
microk8s kubectl apply -f post-service.yaml
microk8s kubectl apply -f frontend.yaml

echo "✅ All services deployed successfully."
echo "🌐 Access the frontend via NodePort: http://<your-server-ip>:30123"
