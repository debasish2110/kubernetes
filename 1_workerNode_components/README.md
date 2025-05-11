# Kubernetes Core Resources Explained

This document provides a comprehensive explanation of Kubernetes core components including Worker Nodes, Pods, ReplicaSets, and Deployments, along with YAML configuration examples for each.

---

## 1. Worker Nodes

### Definition:

A **worker node** is a machine (virtual or physical) where the actual application workloads (containers) run in a Kubernetes cluster.

### Key Components:

* **Kubelet**: Ensures containers are running as expected.
* **Container Runtime**: Executes the containers (e.g., Docker, containerd).
* **Kube-proxy**: Handles network communication.
* **Pods**: Containers run inside pods on the node.

### Types of Worker Nodes:

* **Standard Nodes**: General-purpose.
* **GPU Nodes**: For ML or graphics tasks.
* **High-Memory/Compute Nodes**: For intensive tasks.
* **Spot/Preemptible Nodes**: Cost-effective, fault-tolerant workloads.

---

## 2. Pods

### Definition:

A **Pod** is the smallest and simplest Kubernetes object. It represents a single instance of a running process.

### Characteristics:

* Usually contains **one container**, but can have more.
* Containers in a pod share network and storage.
* **Ephemeral** – not restored if deleted; a new one is created.

### Use Cases:

* **Single-container pods**: Most applications.
* **Multi-container pods**: For tightly coupled helpers (e.g., sidecars).

---

## 3. ReplicaSet

### Definition:

A **ReplicaSet** ensures a specified number of **identical pods** are always running.

### Functions:

* Automatically replaces failed or deleted pods.
* Scales up/down the number of replicas.

### Limitation:

Not typically used directly due to lack of update/rollback strategies.

---

## 4. Deployment

### Definition:

A **Deployment** manages ReplicaSets and provides declarative updates.

### Features:

* Rolling updates and rollbacks.
* Declarative application versions.
* Scales applications.

### How It Works:

* Define a Deployment with a pod template and replica count.
* Kubernetes creates a ReplicaSet.
* ReplicaSet manages the pods.

---

## Architecture Diagram

The diagram below shows how Deployments, ReplicaSets, and Pods relate (refer to generated image in UI):

```
Deployment
   |
   |-- manages --> ReplicaSet
                        |
                        |-- creates/maintains --> Pod 1
                        |-- creates/maintains --> Pod 2
                        |-- creates/maintains --> Pod 3
```

---

## YAML Examples

### Deployment YAML (`nginx-deployment.yaml`):

```yaml
apiVersion: apps/v1               # Kubernetes API version
kind: Deployment                  # Declares this as a Deployment object
metadata:
  name: nginx-deployment         # Name of the Deployment
  labels:
    app: nginx                   # Key-value pairs to identify the Deployment
spec:
  replicas: 3                    # Number of desired pod replicas
  selector:
    matchLabels:
      app: nginx                # Pod selector (must match pod template labels)
  template:
    metadata:
      labels:
        app: nginx              # Labels for pods created by this deployment
    spec:
      containers:
        - name: nginx           # Name of the container
          image: nginx:1.25     # Docker image to use
          ports:
            - containerPort: 80 # Port exposed by the container
```

### ReplicaSet YAML (`nginx-replicaset.yaml`):

```yaml
apiVersion: apps/v1               # API version for ReplicaSet
kind: ReplicaSet                  # Declares this as a ReplicaSet object
metadata:
  name: nginx-replicaset         # Name of the ReplicaSet
  labels:
    app: nginx                   # Metadata labels
spec:
  replicas: 3                    # Desired number of pod replicas
  selector:
    matchLabels:
      app: nginx                # Select pods with this label
  template:
    metadata:
      labels:
        app: nginx              # Labels that must match the selector
    spec:
      containers:
        - name: nginx           # Container name
          image: nginx:1.25     # Container image
          ports:
            - containerPort: 80 # Port to expose in the container
```

### Pod YAML (`nginx-pod.yaml`):

```yaml
apiVersion: v1                    # API version for a Pod
kind: Pod                         # Declares this as a Pod object
metadata:
  name: nginx-pod                # Name of the Pod
  labels:
    app: nginx                   # Metadata labels for the Pod
spec:
  containers:
    - name: nginx                # Name of the container in the Pod
      image: nginx:1.25          # Docker image to use
      ports:
        - containerPort: 80      # Port exposed by the container
```

---

## Summary Table

| Resource       | Use Case                                           | Auto-Healing | Rolling Update | Scaling |
| -------------- | -------------------------------------------------- | ------------ | -------------- | ------- |
| **Pod**        | Debugging, quick test, or single-instance tasks    | ❌ No         | ❌ No           | ❌ No    |
| **ReplicaSet** | Ensures constant number of identical Pods          | ✅ Yes        | ❌ No           | ✅ Yes   |
| **Deployment** | Best for production; manages ReplicaSets & updates | ✅ Yes        | ✅ Yes          | ✅ Yes   |

---

