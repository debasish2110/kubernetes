# 🧠 What is Helm?

Helm is a package manager for Kubernetes. A Helm chart is like a "recipe" for deploying an application or a component in a Kubernetes cluster. It defines how to install, configure, and run an application.

## installation
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

---

## 📁 Chart Structure

```
mychart/
├── Chart.yaml                  # Chart metadata
├── values.yaml                 # Default configuration values
├── README.md                   # Documentation (this file)
├── charts/                     # Sub-charts (dependencies)
├── templates/                  # Kubernetes resource templates
│   ├── deployment.yaml         # Deployment resource
│   ├── service.yaml            # Service definition
│   ├── ingress.yaml            # Ingress resource
│   ├── serviceaccount.yaml     # ServiceAccount for pod permissions
│   ├── hpa.yaml                # Horizontal Pod Autoscaler
│   ├── _helpers.tpl            # Template helpers and macros
│   ├── NOTES.txt               # Post-installation instructions
│   └── tests/
│       └── test-connection.yaml  # Helm test to verify service
```

---

## 📓 Chart Files Explained

### `Chart.yaml`

Contains metadata about the Helm chart like name, version, description, and application version.

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
type: application
version: 0.1.0
appVersion: "1.16.0"
```

### `values.yaml`

Holds the default configuration values for the chart. These values are referenced in the templates.

```yaml
replicaCount: 2

image:
  repository: nginx
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
```

### `templates/deployment.yaml`

Defines the Kubernetes Deployment for your application.

### `templates/service.yaml`

Defines the Kubernetes Service to expose your app internally or externally.

### `templates/ingress.yaml`

(Optional) Configures Ingress rules to expose the application outside the cluster.

### `templates/serviceaccount.yaml`

Creates a ServiceAccount that your application can use to securely access the Kubernetes API.

#### Usage Example in `values.yaml`:

```yaml
serviceAccount:
  create: true
  name: ""
```

### `templates/hpa.yaml`

Sets up Horizontal Pod Autoscaler based on CPU usage.

#### Example values:

```yaml
autoscaling:
  enabled: true
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 80
```

### `templates/tests/test-connection.yaml`

A Helm test that verifies your app is reachable after installation.

#### Run it with:

```bash
helm test <release-name>
```

### `templates/NOTES.txt`

Displays helpful instructions after the chart is installed, like how to access the service.

---

## ⚙️ Helm Commands

### Create a chart:

```bash
helm create mychart
```

### Install the chart:

```bash
helm install my-release ./mychart
```

### Upgrade a release:

```bash
helm upgrade my-release ./mychart
```

### Uninstall a release:

```bash
helm uninstall my-release
```

### Dry run and debug templates:

```bash
helm install my-release ./mychart --dry-run --debug
```

### Run Helm tests:

```bash
helm test my-release
```

---

## 📊 Optional Enhancements

* **ServiceAccount**: Grants fine-grained API access to your pods.
* **HPA**: Automatically scales pods based on resource usage.
* **Tests**: Ensures application readiness post-deployment.
* **NOTES.txt**: Guides users with access instructions and tips.
---
