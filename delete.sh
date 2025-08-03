#!/bin/bash

set -e

echo "🧹 Deleting all microservice deployments and ingress..."

echo "🌐 Deleting Ingresses..."
microk8s kubectl delete -f ingress/app-ingress.yaml || true
microk8s kubectl delete -f monitoring/monitoring-ingress.yaml || true

echo "📊 Deleting Monitoring Stack (Prometheus + Grafana)..."
microk8s kubectl delete -f monitoring/prometheus-configmap.yaml
microk8s kubectl delete -f monitoring/prometheus-deployment.yaml
microk8s kubectl delete -f monitoring/grafana-deployment.yaml
microk8s kubectl delete -f monitoring/grafana-service.yaml

echo "🌐 Deleting Frontend..."
microk8s kubectl delete -f frontend/frontend.yaml

echo "📝 Deleting Post Service..."
microk8s kubectl delete -f post-service/post-service.yaml

echo "👤 Deleting User Service..."
microk8s kubectl delete -f user-service/user-service.yaml

echo "🐘 Deleting Postgres..."
microk8s kubectl delete -f postgres/postgres.yaml
microk8s kubectl delete -f postgres/postgres-configmap.yaml

echo "🗑️ All deployments, services, configmaps, and ingress rules deleted."
