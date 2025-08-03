# simple-app-k8s
chmod +x deploy.sh delete.sh
./deploy.sh     # To deploy
./delete.sh     # To remove


project-root/
├── deploy.sh
├── delete.sh
├── frontend/
│   └── frontend.yaml
├── ingress/
│   └── app-ingress.yaml
├── monitoring/
│   ├── grafana-deployment.yaml
│   ├── grafana-service.yaml
│   ├── monitoring-ingress.yaml
│   ├── prometheus-configmap.yaml
│   └── prometheus-deployment.yaml
├── post-service/
│   └── post-service.yaml
├── postgres/
│   ├── postgres-configmap.yaml
│   └── postgres.yaml
├── user-service/
│   └── user-service.yaml
