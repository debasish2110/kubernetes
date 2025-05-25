# 🔐 Role-Based Access Control (RBAC) in Kubernetes

## 📘 Overview

**RBAC (Role-Based Access Control)** in **Kubernetes (K8s)** is a method for regulating **access to Kubernetes resources** based on the roles of individual users or service accounts. It allows administrators to define **who can do what** within a Kubernetes cluster.

---

## 🎯 Key Concepts in RBAC

1. **Role** – A set of permissions (rules) within a **namespace**.
2. **ClusterRole** – A set of permissions cluster-wide or across **all namespaces**.
3. **RoleBinding** – Grants the defined **Role** to a user, group, or service account **within a namespace**.
4. **ClusterRoleBinding** – Grants a **ClusterRole** to a user, group, or service account **across the entire cluster**.

---

## 🧱 RBAC Object Structure

Each object (Role, RoleBinding, ClusterRole, ClusterRoleBinding) is defined as a YAML file:

### Role Example

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: dev
  name: pod-reader
rules:
- apiGroups: [""]            # "" means the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### RoleBinding Example

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods-binding
  namespace: dev
subjects:
- kind: User
  name: alice                # Name of the user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader           # Role to bind
  apiGroup: rbac.authorization.k8s.io
```

### ClusterRole Example

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin-read
rules:
- apiGroups: [""]
  resources: ["nodes", "pods"]
  verbs: ["get", "list", "watch"]
```

### ClusterRoleBinding Example

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-cluster-binding
subjects:
- kind: User
  name: bob
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin-read
  apiGroup: rbac.authorization.k8s.io
```

---

## 📀 RBAC Flow Summary

1. **User requests** an action on a resource (e.g., get pod).
2. Kubernetes checks:

   * Does the user have a **RoleBinding** (or ClusterRoleBinding)?
   * Does that binding refer to a **Role** (or ClusterRole)?
   * Does the Role contain **permission** for the requested action?

---

## ✅ Benefits of RBAC

* **Security**: Least privilege principle.
* **Granularity**: Assign different roles to devs, QA, and admins.
* **Flexibility**: Bind roles to users, groups, or service accounts.
* **Auditability**: Easy to track what permissions are given.

---

## 🚧 Example Use Case

You want a developer to only **view pods** in the `dev` namespace but not **create/delete** them:

1. Create a Role (`pod-reader`) with `get`, `list`, `watch` verbs.
2. Bind this role to the developer using a RoleBinding.

This ensures that the developer can't affect other namespaces or perform unauthorized actions.

---

If you'd like to apply this, you can use `kubectl apply -f` with the above YAML manifests.
