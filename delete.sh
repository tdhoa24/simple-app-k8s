#!/bin/bash

set -e

echo "🧹 Deleting all microservice deployments..."

echo "🌐 Deleting Frontend..."
microk8s kubectl delete -f frontend/frontend.yaml || true

echo "📝 Deleting Post Service..."
microk8s kubectl delete -f post-service/post-service.yaml || true

echo "👤 Deleting User Service..."
microk8s kubectl delete -f user-service/user-service.yaml || true

echo "🐘 Deleting Postgres..."
microk8s kubectl delete -f postgres/postgres.yaml || true
microk8s kubectl delete -f postgres/postgres-configmap.yaml || true

echo "📉 Deleting App Ingress..."
microk8s kubectl delete -f ingress/app-ingress.yaml || true

echo "📊 Deleting Monitoring Stack (Prometheus + Grafana)..."
microk8s kubectl delete -f monitoring/prometheus-config.yaml || true
microk8s kubectl delete -f monitoring/prometheus-deployment.yaml || true
microk8s kubectl delete -f monitoring/grafana-deployment.yaml || true
microk8s kubectl delete -f monitoring/grafana-service.yaml || true

echo ""
echo "🗑️  All services and Ingress rules have been deleted."
