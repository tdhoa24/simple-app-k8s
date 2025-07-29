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

echo "📊 Deploying monitoring stack (Prometheus & Grafana)..."
microk8s kubectl apply -f monitoring/prometheus-config.yaml
microk8s kubectl apply -f monitoring/prometheus-deployment.yaml
microk8s kubectl apply -f monitoring/grafana-deployment.yaml
microk8s kubectl apply -f monitoring/grafana-service.yaml

echo "✅ All services and monitoring deployed successfully."
echo "🌐 Access the frontend via NodePort: http://192.168.0.140:30123"
echo "📈 Access Prometheus via NodePort: http://192.168.0.140:30900"
echo "📊 Access Grafana via NodePort: http://192.168.0.140:30300"
