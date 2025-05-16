# Kubernetes Service Ports: ClusterIP vs LoadBalancer

This document explains how ports work in Kubernetes for `ClusterIP` and `LoadBalancer` service types, with a comparison table and examples.

---

## 🔹 1. ClusterIP

> Default service type. Exposes the service **internally within the cluster**.

### 🧩 Port Flow:
```
Client inside cluster --> Service Port (port) --> Target Port (on Pod)
```

### ✅ Used Fields:
- **`port`**: The port exposed on the virtual ClusterIP.
- **`targetPort`**: The actual port on the Pod where the app runs.

### ❌ Not Used:
- `nodePort`: Not applicable.

### 📄 Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-clusterip-service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 5000
```

> Access: Only from **within the cluster** (e.g., other Pods).

---

## 🔹 2. LoadBalancer

> Exposes the service **externally** using a **cloud provider's load balancer** (e.g., AWS ELB, Azure LB, GCP LB).

### 🧩 Port Flow:
```
External Client --> LoadBalancer IP:port --> NodePort --> Service Port --> Target Port
```

- Behind the scenes, Kubernetes creates a `NodePort` for each port and provisions a cloud load balancer pointing to it.

### ✅ Used Fields:
- **`port`**: Exposed by the Service (and by the load balancer).
- **`targetPort`**: Pod/container port.
- **`nodePort`**: Optional. Auto-assigned if not specified, but can be manually set.

### 📄 Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-loadbalancer-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 5000
      nodePort: 30080  # Optional
```

> Access: From **outside the cluster**, via the cloud provider's public IP.

---

## 🔍 Summary Table

| Port Type    | ClusterIP | NodePort | LoadBalancer |
|--------------|-----------|----------|--------------|
| `port`       | ✅ Yes    | ✅ Yes   | ✅ Yes       |
| `targetPort` | ✅ Yes    | ✅ Yes   | ✅ Yes       |
| `nodePort`   | ❌ No     | ✅ Yes   | ✅ Yes (auto) |
| External Access | ❌ No | ✅ Yes   | ✅ Yes       |

---

## 📝 Notes

- Use `ClusterIP` when you only need internal access.
- Use `LoadBalancer` when you want to expose services to the internet.
- `nodePort` is managed automatically with `LoadBalancer` but can be customized.
