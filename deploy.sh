#!/bin/bash

set -e

echo "🟢 Deploying microservices to MicroK8s (Ingress-based)..."

echo "📦 Creating ConfigMap for Postgres init.sql..."
microk8s kubectl apply -f postgres/postgres-configmap.yaml

echo "🐘 Deploying Postgres..."
microk8s kubectl apply -f postgres/postgres.yaml

echo "👤 Deploying User Service..."
microk8s kubectl apply -f user-service/user-service.yaml

echo "📝 Deploying Post Service..."
microk8s kubectl apply -f post-service/post-service.yaml

echo "🌐 Deploying Frontend (static site)..."
microk8s kubectl apply -f frontend/frontend.yaml

echo "📊 Deploying Monitoring Stack (Prometheus & Grafana)..."
microk8s kubectl apply -f monitoring/prometheus-configmap.yaml
microk8s kubectl apply -f monitoring/prometheus-deployment.yaml
microk8s kubectl apply -f monitoring/grafana-deployment.yaml
microk8s kubectl apply -f monitoring/grafana-service.yaml
microk8s kubectl apply -f monitoring/monitoring-ingress.yaml

echo "✅ All services and monitoring deployed successfully."
echo "🌍 Access everything via Ingress:"
echo "   🖥️  Frontend:    http://<your-server-ip>/frontend"
echo "   👤  User API:    http://<your-server-ip>/user-service/users"
echo "   📝  Post API:    http://<your-server-ip>/post-service/posts"
echo "   📈  Prometheus:  http://<your-server-ip>/prometheus"
echo "   📊  Grafana:     http://<your-server-ip>/grafana"
