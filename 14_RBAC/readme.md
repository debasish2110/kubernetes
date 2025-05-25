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

## 🤱 RBAC Object Structure

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
   - Does the user have a **RoleBinding** (or ClusterRoleBinding)?  
   - Does that binding refer to a **Role** (or ClusterRole)?  
   - Does the Role contain **permission** for the requested action?

---

## ✅ Benefits of RBAC

- **Security**: Least privilege principle.  
- **Granularity**: Assign different roles to devs, QA, and admins.  
- **Flexibility**: Bind roles to users, groups, or service accounts.  
- **Auditability**: Easy to track what permissions are given.

---

## 🚧 Example Use Case

You want a developer to only **view pods** in the `dev` namespace but not **create/delete** them:

1. Create a Role (`pod-reader`) with `get`, `list`, `watch` verbs.
2. Bind this role to the developer using a RoleBinding.

This ensures that the developer can't affect other namespaces or perform unauthorized actions.

---

## 📝 How RoleBinding.yaml is linked to Role.yaml

The **link between `RoleBinding.yaml` and `Role.yaml`** happens through the **`roleRef` field** in the `RoleBinding` object.

### How `RoleBinding` links to `Role`

In the `RoleBinding` YAML, you specify which Role you want to bind to **subjects** (users, groups, or service accounts).

Here is the critical part in the `RoleBinding.yaml`:

```yaml
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

- `kind`: Specifies the kind of role you are binding to — usually **Role** (namespace-scoped) or **ClusterRole** (cluster-wide).  
- `name`: This is the exact **name** of the Role (or ClusterRole) you want to grant to the subjects.  
- `apiGroup`: Always `rbac.authorization.k8s.io` for RBAC objects.

### Example to clarify:

- You have a `Role` named `pod-reader` in namespace `dev`.  
- Your `RoleBinding` binds that `pod-reader` role to user `alice` in the same `dev` namespace.  
- The `RoleBinding` references the Role by its name (`pod-reader`) under `roleRef`.

So Kubernetes knows:  
**"When alice tries to do something in the `dev` namespace, check permissions defined in the Role called `pod-reader`."**

### Summary

- The `Role` defines the **permissions**.  
- The `RoleBinding` attaches those permissions to a **user, group, or service account**.  
- `roleRef` in `RoleBinding` links to the `Role` by name and kind.

---

If you'd like to apply this, you can use `kubectl apply -f` with the above YAML manifests.
