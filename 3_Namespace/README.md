
# Kubernetes Namespace Overview

## Introduction
A **namespace** in Kubernetes is a way to divide cluster resources between multiple users or teams, enabling resource isolation, access control, and separation of environments. Namespaces help manage large-scale clusters by grouping related resources together, making it easier to apply policies and security controls.

## Key Features of Kubernetes Namespaces:
1. **Resource Isolation**: Namespaces allow you to isolate resources like pods, services, and deployments. This makes it easier to manage and enforce policies for specific groups or applications.
2. **Access Control**: Role-based access control (RBAC) can be applied at the namespace level to grant specific permissions to users or groups for managing resources within that namespace.
3. **Environment Separation**: You can separate different environments (like development, staging, and production) by using different namespaces in the same cluster.

## Default Namespace
By default, Kubernetes provides a `default` namespace for resources that are not explicitly assigned to any other namespace.

## Example
Here’s an example of how to create a pod in a specific namespace:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
  namespace: dev
spec:
  containers:
  - name: example-container
    image: nginx
```
In this example, the pod will be created in the `dev` namespace.

## Common Kubernetes Namespace Commands:
- **List namespaces**: 
  ```bash
  kubectl get namespaces
  ```

- **Create a namespace**:
  ```bash
  kubectl create namespace <namespace-name>
  ```

- **Use a specific namespace**:
  ```bash
  kubectl config set-context --current --namespace=<namespace-name>
  ``` 

## Conclusion
Namespaces in Kubernetes are crucial for managing multi-tenant environments and large-scale clusters. They provide a way to organize and secure cluster resources, making it easier to apply access control, policies, and separation of concerns across different teams or environments.
