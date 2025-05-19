# Kubernetes Scheduling Concepts

This document provides a detailed explanation of Kubernetes scheduling mechanisms that control **where and how Pods are placed** on nodes. Understanding these concepts helps in optimizing resource usage, managing availability, and improving the resilience of your workloads.

**[scheduling-text-notes](https://github.com/debasish2110/kubernetes/blob/master/0_notes/kubernets%20Schedulers.txt)**

---

## 📌 Table of Contents

1. [Kubernetes Scheduler](#kubernetes-scheduler)
2. [NodeSelector](#nodeselector)
3. [Node Affinity](#node-affinity)
   - [RequiredDuringSchedulingIgnoredDuringExecution](#requiredduringschedulingignoredduringexecution)
   - [PreferredDuringSchedulingIgnoredDuringExecution](#preferredduringschedulingignoredduringexecution)
4. [DaemonSet](#daemonset)
5. [Taints and Tolerations](#taints-and-tolerations)

---

## 🧠 Kubernetes Scheduler

The **Kubernetes Scheduler** is the control plane component responsible for assigning Pods to Nodes.

### How It Works:
- Watches for newly created Pods with no assigned node.
- Evaluates the scheduling policies, constraints (affinities, taints, resource requests), and node availability.
- Assigns the Pod to the best-fit Node.

> 🛠️ If no suitable node is found, the Pod will remain in a pending state.

---

## 🎯 NodeSelector

`NodeSelector` is the simplest way to constrain Pods to run on specific Nodes using key-value labels.

### Usage Example:

```yaml
spec:
  nodeSelector:
    disktype: ssd
```

### How It Works:
- The Pod will only be scheduled on a Node with the label `disktype=ssd`.

> ⚠️ Limitation: Only supports **exact matches** and lacks complex rule capabilities.

---

## 🔁 Node Affinity

`NodeAffinity` offers more flexible and expressive rules than `nodeSelector`.

### Syntax Example:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: disktype
          operator: In
          values:
          - ssd
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      preference:
        matchExpressions:
        - key: zone
          operator: In
          values:
          - us-east-1a
```

* Node Affinity in Kubernetes uses `In`, `NotIn`, `Gt`, and `Lt` operators, these are used inside matchExpressions under nodeSelectorTerms.
```yaml
# example of different operators
apiVersion: v1
kind: Pod
metadata:
  name: affinity-demo
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: "zone"
            operator: "In"
            values:
            - us-east-1a
            - us-east-1b
          - key: "instance-type"
            operator: "NotIn"
            values:
            - t2.micro
            - t2.nano
          - key: "cpu-count"
            operator: "Gt"
            values:
            - "2"
          - key: "memory-gb"
            operator: "Lt"
            values:
            - "64"
  containers:
  - name: nginx
    image: nginx
```

### Types:

#### ✅ `requiredDuringSchedulingIgnoredDuringExecution`
- Pod **must** be scheduled to a Node matching the criteria.
- If no matching Node exists, the Pod will remain unscheduled.

#### 🤝 `preferredDuringSchedulingIgnoredDuringExecution`
- Pod **prefers** the specified Node(s), but it’s not mandatory.
- Acts like a "soft" constraint. Scheduler will try to honor it if possible.

---

## 🧱 DaemonSet

A `DaemonSet` ensures that a **copy of a Pod runs on every (or selected) Node** in the cluster.

### Common Use Cases:
- Log collection (e.g., Fluentd)
- Monitoring (e.g., Prometheus Node Exporter)
- Networking (e.g., CNI plugins)

### Example:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemon
spec:
  selector:
    matchLabels:
      app: my-daemon
  template:
    metadata:
      labels:
        app: my-daemon
    spec:
      containers:
      - name: my-container
        image: my-image
```

---

## ⛔ Taints and Tolerations

Taints are applied to nodes, and they repel Pods unless the Pod has a matching toleration.

### Use Case:
To dedicate nodes to specific workloads and prevent general scheduling.
Running critical apps on dedicated nodes.
Keeping test or noisy apps off certain nodes.

### Taint Example:

```bash
kubectl taint nodes node1 key=value:NoSchedule
```

### Toleration Example:
* `Equal` operator(default):
```yaml
tolerations:
- key: "key"
  operator: "Equal"
  value: "value"
  effect: "NoSchedule"
```

* `Exists` opeartor:
```yaml
tolerations:
- key: "environment"
  operator: "Exists"
  effect: "NoSchedule"

```

> 🔄 The Pod with this toleration can be scheduled on nodes with the corresponding taint.

---

## ✅ Summary

| Concept            | Purpose                                     | Pod Impact                               |
|--------------------|---------------------------------------------|-------------------------------------------|
| Scheduler          | Assigns Pods to Nodes                       | Determines Pod placement                  |
| NodeSelector       | Match Pod to specific Nodes via labels      | Hard constraint                           |
| Node Affinity      | Expressive Pod-Node constraints             | Hard (required) or soft (preferred) rules |
| DaemonSet          | Run a Pod on all or specific Nodes          | One Pod per Node                          |
| Taints & Tolerations | Prevent or allow Pods on tainted Nodes    | Controlled Node selection                 |