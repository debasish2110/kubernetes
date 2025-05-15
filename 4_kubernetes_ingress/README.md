# Kubernetes Ingress

This project demonstrates how to configure and use **Kubernetes Ingress** to route external HTTP/HTTPS traffic to internal services in a Kubernetes cluster.

---

## 📦 Prerequisites

* Kubernetes Cluster (Minikube, EKS, GKE, etc.)
* `kubectl` configured to access your cluster
* Ingress Controller (e.g., NGINX Ingress Controller)

---

## 📚 Popular Ingress Controllers

Here is a list of commonly used Ingress controllers in Kubernetes:

1. **NGINX Ingress Controller**

   * Most widely used
   * Easy to set up
   * Good community support
   * [Docs](https://kubernetes.github.io/ingress-nginx/)

2. **HAProxy Ingress Controller**

   * High performance and flexibility
   * [Docs](https://haproxy-ingress.github.io/)

3. **Traefik Ingress Controller**

   * Lightweight and dynamic configuration
   * Native Let's Encrypt support
   * [Docs](https://doc.traefik.io/traefik/)

4. **AWS ALB Ingress Controller**

   * Integrates with AWS Application Load Balancer
   * [Docs](https://kubernetes-sigs.github.io/aws-load-balancer-controller/)

5. **Istio Ingress Gateway**

   * Part of Istio service mesh
   * Offers advanced traffic control and observability
   * [Docs](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/)

6. **Contour**

   * Powered by Envoy proxy
   * High performance and rich features
   * [Docs](https://projectcontour.io/)

---

## ⚖️ Ingress Controller vs LoadBalancer Service vs AWS ELB

| Feature                 | Ingress Controller                       | LoadBalancer Service              | AWS ELB (External to Kubernetes)   |
| ----------------------- | ---------------------------------------- | --------------------------------- | ---------------------------------- |
| **Resource Efficiency** | Single entry point for multiple services | One LoadBalancer per service      | One ELB per service (manual setup) |
| **Cost**                | More cost-effective (shared entry point) | Higher cost (each service has LB) | High cost (pay-per-ELB)            |
| **Path-based Routing**  | Yes                                      | No                                | No                                 |
| **TLS Termination**     | Yes (via annotations + certs)            | Yes (via service annotations)     | Yes                                |
| **Ease of Setup**       | Medium (requires controller deployment)  | Easy (native Kubernetes support)  | Manual setup                       |
| **Flexibility**         | High (annotations, rules, rewrites)      | Limited                           | Medium                             |
| **Cloud Agnostic**      | Yes                                      | Depends on cloud provider         | AWS-specific                       |

---

## 🚀 Setup Instructions

### 1. Install NGINX Ingress Controller (for Minikube):

```bash
minikube addons enable ingress
```

For other environments, use Helm:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

### 2. Deploy Sample Services

```yaml
# app1-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: app1-service
spec:
  selector:
    app: app1
  ports:
    - port: 80
      targetPort: 8080
```

### 3. Create Ingress Resource

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

### 4. Apply Configurations

```bash
kubectl apply -f app1-service.yaml
kubectl apply -f app2-service.yaml
kubectl apply -f ingress.yaml
```

### 5. Access the Services

Add the following to your `/etc/hosts` file:

```
<minikube_ip> example.com
```

Then visit:

* `http://example.com/app1`
* `http://example.com/app2`

---

## 🔐 Enable TLS (Optional)

```yaml
spec:
  tls:
  - hosts:
    - example.com
    secretName: example-tls
```

Use [cert-manager](https://cert-manager.io/docs/) to automate certificate management.

---

## 📘 Resources

* [Kubernetes Ingress Docs](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)

---
