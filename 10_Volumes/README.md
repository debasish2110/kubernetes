# What is a Kubernetes Volume?
In Kubernetes, a Volume is a directory, possibly with some data in it, which is accessible to containers running in a Pod. Unlike Docker containers where files in the container’s writable layer disappear when the container stops, Kubernetes Volumes outlive containers in the Pod and can be shared between containers.

## Why do we need Volumes in Kubernetes?
### Containers are ephemeral by design. When a container crashes or restarts:
- The container’s writable filesystem is lost.
- Any data stored inside the container’s filesystem disappears.

### Kubernetes Volumes provide a way to:
- Persist data beyond the lifecycle of a single container.
- Share data between containers in the same Pod.
- Access external storage like network drives, cloud storage, or host machine disks.

## How do Volumes work in Kubernetes?
- A Pod can declare one or more Volumes.
- Containers inside the Pod can mount these Volumes to specific paths inside the container’s filesystem.
- The lifecycle of a Volume is tied to the Pod, not individual containers.
- When the Pod is deleted, the Volume is also deleted unless it's backed by an external storage system.

## Volume Lifecycle and Mounting
- When a Pod starts, the Volume is provisioned or attached.
- Containers declare a volumeMount which maps the Volume to a container path.
- Containers can read/write to the Volume as if it were part of their filesystem.
- When the Pod is deleted, ephemeral Volumes like emptyDir are deleted; persistent Volumes remain.

---

# Kubernetes AWS EBS CSI Driver Installation and Volume Concepts

## Prerequisites

- A running EKS cluster
- EC2 node group IAM Role with **full EC2 access** or **admin access** to allow EBS volume creation

---

## Step 1: Install Helm CLI

Helm is a package manager for Kubernetes that simplifies installation of Kubernetes applications.

```bash
# Download Helm v3.14.0 for Linux
wget https://get.helm.sh/helm-v3.14.0-linux-amd64.tar.gz

# Extract the tarball
tar -zxvf helm-v3.14.0-linux-amd64.tar.gz

# Move Helm binary to /usr/local/bin
sudo mv linux-amd64/helm /usr/local/bin/helm

# Set executable permissions
sudo chmod 777 /usr/local/bin/helm

# Verify Helm installation
helm version
```

---

## Step 2: Install AWS EBS CSI Driver on EKS Cluster

The AWS EBS CSI driver allows Kubernetes to manage AWS Elastic Block Store volumes dynamically.

1. Add the AWS EBS CSI driver Helm repo and update:

```bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
```

2. Install or upgrade the AWS EBS CSI driver in the `kube-system` namespace:

```bash
helm upgrade --install aws-ebs-csi-driver --namespace kube-system aws-ebs-csi-driver/aws-ebs-csi-driver
```

---

## Volume Creation Approaches

1. **Static Host Path Volumes**
   - Defined via PV, PVC, and Deployment.
   - Not recommended for production.
   - If the node is deleted, the volumes are deleted as well.

2. **Static Cloud EBS Volumes**
   - Manually create AWS EBS volumes.
   - PV, PVC, and Deployment bind to these volumes.
   - Persistent even if nodes are deleted.
   - Manual volume management required.

3. **Dynamic Volume Provisioning (Recommended)**
   - Use StorageClass and PVC.
   - PVs are automatically created by the StorageClass.
   - Supports dynamic provisioning of EBS volumes.

---

## Volume Access Modes

| Access Mode     | Description                                                                                           | Use Case                                                                                  |
|-----------------|---------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| ReadWriteMany   | Multiple pods across nodes can read and write to the volume.                                        | When multiple Pods need to write concurrently on different nodes, and the plugin supports it. |
| ReadWriteOnce   | Volume can be mounted as read-write by a single node.                                              | When only one Pod/node needs write access.                                               |
| ReadOnlyMany    | Volume can be mounted read-only by many nodes.                                                     | When multiple Pods need read-only access across nodes.                                   |

**Notes:**

- If ReadWriteMany or ReadOnlyMany is not supported, use ReadWriteOnce as fallback.
- For read-only volumes, use `containers.volumeMounts.readOnly: true` as a best practice.

---

## Persistent Volume Claim (PVC) Reclaim Policies

- **Delete** (default): When a PVC is deleted, the associated PV and storage are deleted automatically if created by StorageClass.  
  *Note:* For AWS EBS volumes, the volume is NOT deleted automatically; you must delete it manually.

- **Retain**: The PV and storage remain after the PVC is deleted, preserving the data.

---

## Volume Binding Modes

- **Immediate** (default): PV is bound immediately when PVC is created.
- **WaitForFirstConsumer**: PV is provisioned only when a Pod using the PVC is scheduled.

---

## Notes

- After cluster creation, attach **EC2 Full Access** or **Admin Access** IAM role to node group for EBS volume creation.
- Dynamic provisioning is recommended for easier volume management.
