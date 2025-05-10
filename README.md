# Kubernetes Architecture

Kubernetes (K8s) is an open-source container orchestration system designed to automate the deployment, scaling, and management of containerized applications. This document provides an in-depth look at the architecture of Kubernetes, covering all the key components, their roles, and interactions within a Kubernetes cluster.

---

## Table of Contents

1. [Overview](#overview)
2. [Kubernetes Components](#kubernetes-components)

   * [Control Plane](#control-plane)
   * [Node Components](#node-components)
3. [Pod Architecture](#pod-architecture)
4. [Workload Controllers](#workload-controllers)
5. [Networking Components](#networking-components)
6. [Storage Architecture](#storage-architecture)
7. [Additional Concepts](#additional-concepts)
8. [High-Level Diagram](#high-level-diagram)
9. [Conclusion](#conclusion)

---

## Overview

Kubernetes uses a declarative configuration system and an immutable infrastructure paradigm to manage clusters consisting of multiple nodes. These nodes run containerized applications in Pods, the smallest deployable units in Kubernetes. The system constantly reconciles the desired state defined in configuration files with the actual state of the system.

---

## Kubernetes Components

### Control Plane

The control plane is responsible for the global decisions about the cluster and detecting/responding to cluster events. It consists of the following components:

#### 1. kube-apiserver

* Acts as the front-end for the Kubernetes control plane.
* Exposes the Kubernetes API.
* Validates and processes REST requests from clients.
* Handles all communications between cluster components via the API.

#### 2. etcd

* A consistent and highly-available key-value store used as Kubernetes' backing store.
* Stores the entire state of the cluster.
* Only the kube-apiserver interacts directly with etcd.

#### 3. kube-scheduler

* Watches for unassigned Pods and binds them to suitable nodes.
* Scheduling decisions are based on resource availability, affinity/anti-affinity rules, taints/tolerations, and custom policies.

#### 4. kube-controller-manager

* Runs various controllers that handle routine tasks:

  * **Node Controller** – detects node failures.
  * **Replication Controller** – ensures the correct number of pod replicas.
  * **Endpoint Controller** – populates Service endpoints.
  * **Namespace Controller** – handles lifecycle of namespaces.
  * **ServiceAccount Controller** – manages default accounts and tokens.

#### 5. cloud-controller-manager

* Integrates with cloud provider APIs.
* Manages cloud-specific components like:

  * Node initialization and shutdown.
  * Load balancer and network routes.
  * Persistent volume provisioning.

---

### Node Components

Each worker node runs the services necessary to support the running Pods:

#### 1. kubelet

* The primary "node agent".
* Registers the node with the API server.
* Ensures the containers described in PodSpecs are running and healthy.

#### 2. kube-proxy

* Maintains network rules for Pod communication.
* Provides service discovery and load balancing.
* Supports IPTables and IPVS-based traffic routing.

#### 3. Container Runtime

* The software responsible for running containers.
* Common runtimes:

  * containerd
  * CRI-O
  * Docker (deprecated as of Kubernetes v1.24)

---

## Pod Architecture

A **Pod** is the smallest deployable unit in Kubernetes and can contain one or more tightly coupled containers that share:

* **Storage volumes**
* **Network IP and port space**
* **Process namespace (optionally)**

Pods are ephemeral and usually managed by higher-level controllers that handle scheduling and replication.

---

## Workload Controllers

Kubernetes provides several controllers to manage application deployment and scaling:

### ReplicaSet

* Ensures a specific number of pod replicas are running at any given time.

### Deployment

* Provides declarative updates for Pods and ReplicaSets.
* Enables rolling updates, rollbacks, and pause/resume functionality.

### StatefulSet

* Manages stateful applications.
* Maintains a unique identity and stable storage for each Pod.

### DaemonSet

* Ensures a copy of a Pod runs on all or selected nodes.
* Useful for logging, monitoring, and networking services.

### Job and CronJob

* **Job**: Runs Pods to completion.
* **CronJob**: Schedules Jobs to run periodically at fixed times.

---

## Networking Components

### Cluster Networking

* Every Pod gets its own IP address.
* All containers within a Pod share the same network namespace.

### Services

* Abstracts a set of Pods into a single IP and DNS name.
* Types:

  * **ClusterIP**: Internal communication.
  * **NodePort**: Exposes service on each Node's IP at a static port.
  * **LoadBalancer**: Integrates with cloud load balancers.
  * **ExternalName**: Maps to external DNS names.

### Network Policies

* Controls traffic flow at the IP address or port level.
* Implements rules for ingress and egress communication.

---

## Storage Architecture

### Volumes

* Provides persistent or temporary storage for Pods.
* Supports multiple backends: hostPath, NFS, emptyDir, etc.

### Persistent Volumes (PVs) & Persistent Volume Claims (PVCs)

* Decouples storage provisioning from Pod definition.
* **PV**: Storage resource provisioned by admin.
* **PVC**: Storage request by user.

### Storage Classes

* Enables dynamic provisioning of volumes.
* Specifies parameters like volume type, IOPS, reclaim policy.

---

## Additional Concepts

### ConfigMaps

* Store configuration data in key-value pairs.
* Mounted into Pods as files or environment variables.

### Secrets

* Store sensitive data such as passwords and API keys.
* Encoded in base64 and mounted similarly to ConfigMaps.

### Namespaces

* Virtual clusters within a Kubernetes cluster.
* Provide resource isolation and scoping.

---

## High-Level Diagram

```plaintext
+-----------------------------------------------------------+
|                        Control Plane                      |
|                                                           |
|  +-------------+   +----------------------+               |
|  | kube-apiserver |<->|      etcd          |              |
|  +-------------+   +----------------------+               |
|       |                                                   |
|       v                                                   |
|  +----------------+   +--------------------------+        |
|  | kube-scheduler |   | kube-controller-manager  |        |
|  +----------------+   +--------------------------+        |
|       |                                                   |
|       v                                                   |
|  +----------------------+                                 |
|  | cloud-controller-mgr |                                 |
|  +----------------------+                                 |
+-----------------------------------------------------------+
         |                      |                    
         v                      v                    
+-------------------+    +-------------------+       
|   Worker Node 1   |    |   Worker Node 2   |       
|-------------------|    |-------------------|       
| kubelet           |    | kubelet           |       
| kube-proxy        |    | kube-proxy        |       
| container runtime |    | container runtime |       
| Pods              |    | Pods              |       
+-------------------+    +-------------------+       
```

---

## Conclusion

Kubernetes provides a powerful, flexible platform for running containerized workloads and services. Its modular architecture enables high availability, scalability, and fault tolerance. Understanding each component and their interactions is key to designing robust and efficient applications on Kubernetes.

For more information, consult the [official Kubernetes documentation](https://kubernetes.io/docs/).
