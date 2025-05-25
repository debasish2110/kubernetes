# 📦 Kubernetes Manifests Explained

In **Kubernetes**, a **manifest** is a YAML (or JSON) configuration file that defines the **desired state** of a Kubernetes resource.

These files are declarative, meaning you specify **what you want**, and Kubernetes will take care of creating and maintaining the state.

---

## 🧱 What is a Kubernetes Manifest?

A **manifest** defines Kubernetes objects such as:

* Pods
* Deployments
* Services
* StatefulSets
* ConfigMaps
* Secrets
* Volumes

Each manifest is a `.yaml` or `.json` file that includes fields like:

```yaml
apiVersion: <API version>
kind: <Object type>
metadata:
  name: <Object name>
spec:
  <Desired state of the object>
```

---

## ✍️ Example: Pod Manifest

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-nginx-pod
spec:
  containers:
    - name: nginx-container
      image: nginx:latest
      ports:
        - containerPort: 80
```

---

## 📦 Example: Deployment Manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx-deployment
spec:
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
        image: nginx:latest
        ports:
        - containerPort: 80
```

---

## ⚙️ How to Apply a Manifest

Use `kubectl apply` to create or update resources:

```bash
kubectl apply -f <filename>.yaml
```

Example:

```bash
kubectl apply -f my-nginx-deployment.yaml
```

---

## 📋 Common Manifest Fields

| Field        | Description                                        |
| ------------ | -------------------------------------------------- |
| `apiVersion` | API version used for the resource                  |
| `kind`       | Type of Kubernetes object                          |
| `metadata`   | Metadata like name, namespace, labels, annotations |
| `spec`       | Detailed configuration for the resource            |

---

## 📁 Organizing Manifests

You can group multiple manifests into a directory and apply them together:

```bash
kubectl apply -f ./manifests/
```

File structure:

```
manifests/
├── pod.yaml
├── service.yaml
├── deployment.yaml
```

---

## ✅ Summary

Kubernetes manifests are essential for defining and managing infrastructure as code. They enable repeatable, version-controlled, and scalable deployments.

Happy deploying! 🚀
