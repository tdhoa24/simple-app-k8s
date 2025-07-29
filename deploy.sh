#!/bin/bash

set -e

echo "🟢 Deploying microservices to MicroK8s..."

echo "📦 Creating ConfigMap for Postgres init.sql..."
microk8s kubectl apply -f postgres/postgres-configmap.yaml

echo "🐘 Deploying Postgres..."
microk8s kubectl apply -f postgres/postgres.yaml

echo "👤 Deploying User Service..."
microk8s kubectl apply -f user-service/user-service.yaml

echo "📝 Deploying Post Service..."
microk8s kubectl apply -f post-service/post-service.yaml

echo "🌐 Deploying Frontend..."
microk8s kubectl apply -f frontend/frontend.yaml

echo "✅ All services deployed successfully."
echo "🌍 Access the frontend at: http://localhost:30123"
