# 🧠 Kubernetes Headless Service Explained

A **Headless Service** in Kubernetes is a special type of service that **does not allocate a ClusterIP**, enabling direct access to individual **Pod IPs**. This is useful for **stateful applications** or use cases where each Pod must be **individually addressable**.

---

## 📌 What is a Headless Service?

In a standard Kubernetes `Service`, a single virtual IP (ClusterIP) is assigned, and requests are load-balanced across the available Pods.

In contrast, a **Headless Service** is created by setting:

```yaml
clusterIP: None
```

This instructs Kubernetes **not to assign a ClusterIP**, and instead to create DNS entries for the individual Pod IPs. This is ideal for:

* **Service discovery**
* **Peer-to-peer communication**
* **Stateful applications** (e.g., databases like Cassandra, MySQL clusters)

---

## 🔧 Use Cases for Headless Services

* **StatefulSets**: Give each Pod a stable network identity (e.g., `pod-0`, `pod-1`)
* **Custom Load Balancing**: When you want to manage how clients connect to specific Pods
* **Direct Pod Discovery**: DNS resolves to Pod IPs instead of a service IP

---

## 🛠️ Example: Headless Service with StatefulSet (NGINX)

### 1. Headless Service YAML (headless-service.yaml)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
  labels:
    app: nginx
spec:
  clusterIP: None
  selector:
    app: nginx
  ports:
    - port: 80
      name: web
```

This creates a DNS name like:

```
nginx-headless.default.svc.cluster.local
```

Which resolves to individual Pod IPs.

---

### 2. StatefulSet YAML (statefulset.yaml)

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx
spec:
  serviceName: "nginx-headless"
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

This results in Pods with stable DNS names:

* `nginx-0.nginx-headless.default.svc.cluster.local`
* `nginx-1.nginx-headless.default.svc.cluster.local`
* `nginx-2.nginx-headless.default.svc.cluster.local`

---

### 3. Apply the YAML files

```bash
kubectl apply -f headless-service.yaml
kubectl apply -f statefulset.yaml
```

---

### 4. DNS Resolution Test

Exec into one of the pods:

```bash
kubectl exec -it nginx-0 -- /bin/bash
```

Install DNS utilities (if needed):

```bash
apt update && apt install -y dnsutils
```

Test DNS resolution:

```bash
nslookup nginx-headless
```

Expected output:

```
Name:   nginx-headless.default.svc.cluster.local
Addresses: <Pod-IP-1>
           <Pod-IP-2>
           <Pod-IP-3>
```

---

## 📋 Summary

| Feature        | ClusterIP Service | Headless Service (`clusterIP: None`) |
| -------------- | ----------------- | ------------------------------------ |
| DNS name       | One IP            | Resolves to all Pod IPs              |
| Load Balancing | Yes (Kube-proxy)  | No                                   |
| Use case       | Stateless apps    | Stateful apps, peer-to-peer, etc.    |

---

## 📂 Full Manifest Bundle

**Directory Structure:**

```
headless-nginx/
├── headless-service.yaml
├── statefulset.yaml
├── README.md
```

**headless-service.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
  labels:
    app: nginx
spec:
  clusterIP: None
  selector:
    app: nginx
  ports:
    - port: 80
      name: web
```

**statefulset.yaml**

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx
spec:
  serviceName: "nginx-headless"
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

You can deploy everything with:

```bash
kubectl apply -f headless-nginx/
```

Let me know if you'd like to include a cleanup script or extend this for a database example!
