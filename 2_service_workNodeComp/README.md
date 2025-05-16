# Kubernetes Service Ports Explained

This document provides a clear explanation of the differences between **NodePort**, **Service Port**, and **Target Port** in Kubernetes networking.

## 🔹 1. Target Port

- **Definition**: The port on the Pod (container) where the application is running.
- **Field**: `targetPort`
- **Purpose**: This is the internal port that the containerized application listens on (e.g., a Flask app on port 5000).

## 🔹 2. Service Port

- **Definition**: The port exposed by the Kubernetes Service within the cluster.
- **Field**: `port`
- **Purpose**: This is the port through which other components in the cluster communicate with the service.

## 🔹 3. NodePort

- **Definition**: The port exposed on each Node’s IP address for external access.
- **Field**: `nodePort`
- **Purpose**: Enables access to the service from outside the cluster using `<NodeIP>:<NodePort>`.
- **Default Range**: 30000–32767

## 🔁 Example YAML

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80          # Service Port
      targetPort: 5000  # Target Port (inside Pod)
      nodePort: 30080   # NodePort (external access)
```

### Explanation:
- Your application runs on **port 5000** inside the Pod (`targetPort`).
- The Service exposes it within the cluster on **port 80** (`port`).
- The application is accessible **externally** using `<NodeIP>:30080` (`nodePort`).

## 🔍 Summary Table

| Port Type    | Field Name   | Defined In     | Access Scope           |
|--------------|--------------|----------------|------------------------|
| Target Port  | `targetPort` | Pod/Container  | Internal to Pod        |
| Service Port | `port`       | Service        | Internal to Cluster    |
| NodePort     | `nodePort`   | Node           | External via Node IP   |

---

## 📝 Notes

- `targetPort` can be the same as `port`, but they can differ.
- You only define `nodePort` when the service type is `NodePort` or `LoadBalancer`.
- For production, consider using `LoadBalancer` or Ingress for more flexible and secure traffic routing.
