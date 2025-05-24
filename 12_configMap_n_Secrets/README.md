# Kubernetes ConfigMaps and Secrets

Kubernetes provides two resources for managing application configuration and sensitive data:

- **ConfigMaps**: Store non-sensitive configuration data
- **Secrets**: Store sensitive data such as passwords and tokens

---

## 🔧 ConfigMap

### Purpose

Used to store **non-sensitive** information such as environment variables, configuration settings, or command-line arguments.

### Example

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_ENV: production
  LOG_LEVEL: debug
```

### Usage in a Pod

```yaml
env:
- name: APP_ENV
  valueFrom:
    configMapKeyRef:
      name: my-config
      key: APP_ENV
```

---

## 🔐 Secret

### Purpose

Used to store **sensitive** data such as API keys, database credentials, SSH keys, and TLS certificates.

### Example

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  DB_PASSWORD: cGFzc3dvcmQxMjM=  # base64 encoded "password123"
```

### Usage in a Pod

```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: my-secret
      key: DB_PASSWORD
```

---

## ⚖️ Key Differences

| Feature        | ConfigMap       | Secret         |
|----------------|------------------|----------------|
| Data Type      | Plaintext        | Base64-encoded (can be encrypted at rest) |
| Use Case       | Non-sensitive config | Sensitive data (passwords, tokens) |
| Security       | Not encrypted by default | Encrypted by default in Kubernetes |
| Mount Options  | As env vars, volumes | Same as ConfigMap |

---

> 💡 For mounting as volumes or using files, refer to the official Kubernetes documentation.
