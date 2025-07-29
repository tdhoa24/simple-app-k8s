#!/bin/bash

echo "🧹 Deleting all microservice deployments..."

echo "🌐 Deleting Frontend..."
microk8s kubectl delete -f frontend/frontend.yaml

echo "📝 Deleting Post Service..."
microk8s kubectl delete -f post-service/post-service.yaml

echo "👤 Deleting User Service..."
microk8s kubectl delete -f user-service/user-service.yaml

echo "🐘 Deleting Postgres..."
microk8s kubectl delete -f postgres/postgres.yaml
microk8s kubectl delete -f postgres/postgres-configmap.yaml

echo "🗑️ All services deleted."
