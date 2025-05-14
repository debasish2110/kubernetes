# Kubernetes: Replica vs Horizontal Pod Autoscaler (HPA)

This document explains the difference between **Replica** and **Horizontal Pod Autoscaler (HPA)** in Kubernetes, how each works, and when to use them.

---

## 📌 What is Horizontal Pod Autoscaling (HPA)?

**Horizontal Pod Autoscaling (HPA)** is a Kubernetes feature that automatically adjusts the number of pod replicas in a deployment, replica set, or stateful set based on observed **CPU utilization** or other **custom metrics** (like memory usage, request rate, etc.).

### 🔧 How HPA Works:

1. **Metrics Collection**: Kubernetes collects metrics using the **Metrics Server**.
2. **Evaluation**: At regular intervals (default every 15 seconds), HPA evaluates if the number of pods should be increased or decreased based on the target metric.
3. **Scaling Decision**: It calculates the desired number of replicas using a formula:

   ```
   desiredReplicas = currentReplicas × ( currentMetric / targetMetric )
   ```
4. **Update**: It adjusts the number of pods in the deployment accordingly.

### 📌 Example:

You have a deployment with 3 pods, each using 80% CPU, and the HPA target is 50%.

Using the formula:

```
desiredReplicas = 3 × (80 / 50) = 4.8 → rounded to 5
```

HPA will scale the deployment to **5 pods**.

### 🧰 Key Requirements:

* Kubernetes >= v1.6
* Metrics Server must be installed and running.
* CPU/Memory-based scaling works out of the box; custom metrics need additional configuration.

### 🛠 Example YAML for HPA:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

### ✅ Benefits:

* Better **resource efficiency**
* Handles **traffic spikes automatically**
* Works well in **cloud-native environments**

---

## 🔁 Replica (via ReplicaSet/Deployment)

### What is a Replica?

A **replica** ensures a fixed number of identical pods are running at any given time.

| Feature          | Description                                                               |
| ---------------- | ------------------------------------------------------------------------- |
| **What it does** | Ensures a **fixed number** of pod replicas are running at all times.      |
| **How it works** | You **manually specify** the number of replicas (e.g., `replicas: 3`).    |
| **Scaling**      | **Manual** – you need to update the value if you want more or fewer pods. |
| **Use case**     | Best for workloads with **stable and predictable traffic**.               |

#### Example:

```yaml
spec:
  replicas: 3
```

---

## 📈 Horizontal Pod Autoscaler (HPA)

### What is HPA?

**Horizontal Pod Autoscaling (HPA)** is a Kubernetes feature that automatically adjusts the number of pod replicas in a deployment, replica set, or stateful set based on observed **CPU utilization** or other **custom metrics**.

| Feature          | Description                                                                                 |
| ---------------- | ------------------------------------------------------------------------------------------- |
| **What it does** | **Automatically adjusts** the number of pods based on CPU/memory/custom metrics.            |
| **How it works** | You define a **range** (minReplicas to maxReplicas), and Kubernetes adjusts it dynamically. |
| **Scaling**      | **Automatic** – based on real-time metrics (e.g., CPU > 50%).                               |
| **Use case**     | Ideal for applications with **variable traffic/load**.                                      |

#### Example:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

### How HPA Works:

1. **Metrics Collection**: Kubernetes collects metrics using the **Metrics Server**.
2. **Evaluation**: HPA evaluates metrics every 15 seconds.
3. **Scaling Decision**: Uses the formula:

   ```
   desiredReplicas = currentReplicas × ( currentMetric / targetMetric )
   ```
4. **Update**: Kubernetes updates the number of pods based on calculated value.

#### Example Calculation:

* Current replicas: 3
* Observed CPU usage: 80%
* Target CPU: 50%

```
desiredReplicas = 3 × (80 / 50) = 4.8 → rounded to 5
```

Kubernetes will scale the deployment to **5 pods**.

---

## ✅ Summary

| Aspect              | Replica (Deployment) | HPA                                     |
| ------------------- | -------------------- | --------------------------------------- |
| Control Type        | Manual               | Automatic                               |
| Scalability         | Static               | Dynamic                                 |
| Use of Metrics      | No                   | Yes                                     |
| Configuration Field | `replicas`           | `minReplicas`, `maxReplicas`, `metrics` |
| Best For            | Consistent workloads | Workloads with changing demand          |

---

## 🔄 Combining Replica and HPA

You can define a base number of replicas in a Deployment and use HPA to dynamically scale within a specified range.

