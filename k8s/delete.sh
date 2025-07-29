#!/bin/bash

echo "🧹 Deleting all microservice deployments..."

microk8s kubectl delete -f frontend.yaml
microk8s kubectl delete -f post-service.yaml
microk8s kubectl delete -f user-service.yaml
microk8s kubectl delete -f postgres.yaml

echo "🗑️ All services deleted."
