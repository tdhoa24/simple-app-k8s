# 🧩 Simple Microservices App on Kubernetes (MicroK8s)

This project demonstrates a simple microservices architecture deployed on [**MicroK8s**](https://microk8s.io/), using:

- A **PostgreSQL** database
- Two backend services: **User Service** and **Post Service**
- A **Frontend** to consume the APIs
- A full **monitoring stack** with **Prometheus** and **Grafana**
- All traffic routed via **Ingress (NGINX)**

---

## 🚀 Project Structure - YAML

project-root/
├── deploy.sh # Deploy all resources
├── delete.sh # Tear down all resources
│
├── frontend/
│ └── frontend.yaml # Static frontend deployment & service
│
├── ingress/
│ └── app-ingress.yaml # Ingress for frontend & backend APIs
│
├── monitoring/
│ ├── grafana-deployment.yaml # Grafana deployment
│ ├── grafana-service.yaml # Grafana service
│ ├── monitoring-ingress.yaml # Ingress for Prometheus & Grafana
│ ├── prometheus-configmap.yaml
│ └── prometheus-deployment.yaml
│
├── post-service/
│ └── post-service.yaml # Post API (backend)
│
├── postgres/
│ ├── postgres-configmap.yaml # init.sql configmap
│ └── postgres.yaml # PostgreSQL deployment & service
│
├── user-service/
│ └── user-service.yaml # User API (backend)

## 🛠️ Prerequisites

- [MicroK8s](https://microk8s.io/) installed and running
- Enable required MicroK8s add-ons:
  ```bash
  microk8s enable dns ingress storage

📦 Deployment
1. Make scripts executable:
bash
chmod +x deploy.sh delete.sh

2. Deploy all services:
bash
./deploy.sh
🧹 Teardown
To delete all deployed resources:

bash
./delete.sh
🌐 Accessing the Services (via Ingress)
Replace <your-server-ip> with the IP of your MicroK8s node.

Service	URL
🖥️ Frontend UI	http://<your-server-ip>/frontend
👤 User API	http://<your-server-ip>/user-service/users
📝 Post API	http://<your-server-ip>/post-service/posts
📈 Prometheus UI	http://<your-server-ip>/prometheus
📊 Grafana Dashboard	http://<your-server-ip>/grafana

📊 Monitoring
Prometheus scrapes metrics from your services.

Grafana is set up to visualize these metrics.

Default ports:

Prometheus: 9090

Grafana: 3000 (default login: admin / admin)

All access is routed via Ingress (no NodePorts used).

📚 Notes
All services use ClusterIP internally. Traffic is exposed via NGINX Ingress.

Designed for local development or internal cluster usage.

You can modify Ingress hosts or paths via:

ingress/app-ingress.yaml

monitoring/monitoring-ingress.yaml

For custom domain names or HTTPS:

Use cert-manager + Let's Encrypt

ingress for DNS: - host: abc.de 

IF microk8s running on localhost :

microk8s kubectl -n ingress patch daemonset nginx-ingress-microk8s-controller --type='json' -p='[{"op": "add", "path": "/spec/template/spec/hostNetwork", "value": true}]'

microk8s kubectl -n ingress patch daemonset nginx-ingress-microk8s-controller --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/dnsPolicy", "value": "ClusterFirstWithHostNet"}]'
THEN
 microk8s kubectl -n ingress get pods -o wide
ss -tuln | grep 30080

📎 License
This project is open-source and available for educational and personal use.

