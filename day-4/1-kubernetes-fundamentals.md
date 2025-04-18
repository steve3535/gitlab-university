# Kubernetes Fundamentals: Core Concepts and Components

Welcome to the first part of our Kubernetes integration with GitLab course! Before we dive into GitLab's Kubernetes integration features, we need to establish a solid understanding of Kubernetes itself.

## Learning Objectives

By the end of this lesson, you will:
- Understand the core concepts of Kubernetes
- Recognize key Kubernetes components and their functions
- Deploy a simple application manually to Kubernetes
- Interact with Kubernetes using kubectl commands

## What is Kubernetes?

Kubernetes (often abbreviated as K8s) is an open-source container orchestration platform designed to automate the deployment, scaling, and management of containerized applications. Originally developed by Google and now maintained by the Cloud Native Computing Foundation (CNCF), Kubernetes has become the industry standard for container orchestration.

### Why Kubernetes?

- **Scalability**: Easily scale applications up or down based on demand
- **Self-healing**: Automatically restarts containers that fail, replaces containers, and kills containers that don't respond to health checks
- **Service discovery**: Containers can find each other via DNS or environment variables
- **Load balancing**: Distributes network traffic to ensure deployments are stable
- **Automated rollouts/rollbacks**: Change application deployments with zero downtime
- **Configuration management**: Manage configuration without rebuilding container images
- **Storage orchestration**: Automatically mount storage systems of your choice

## Kubernetes Architecture

Kubernetes follows a master-worker architecture:

### Control Plane (Master Node) Components:

- **API Server**: The front end of the Kubernetes control plane. All operations are coordinated through it.
- **etcd**: A highly available key-value store used as Kubernetes' backing store for all cluster data.
- **Scheduler**: Watches for newly created Pods with no assigned node, and selects a node for them to run on.
- **Controller Manager**: Runs controller processes that regulate the state of the cluster.
- **Cloud Controller Manager**: Links your cluster into your cloud provider's API.

### Worker Node Components:

- **kubelet**: An agent that ensures containers are running in a Pod.
- **kube-proxy**: A network proxy that maintains network rules on nodes.
- **Container Runtime**: The software responsible for running containers (e.g., Docker, containerd).

## Core Kubernetes Concepts

### 1. Pods

Pods are the smallest deployable units in Kubernetes. A Pod represents a single instance of a running process in your cluster and can contain one or more containers.

Key characteristics:
- Containers within a Pod share the same network namespace (IP address and port space)
- Containers within a Pod can communicate via localhost
- Pods are ephemeral by nature - they are not designed to persist

Example Pod manifest:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

### 2. Deployments

Deployments provide declarative updates for Pods. They allow you to:
- Deploy a replica set (multiple copies of your application)
- Update Pods (rolling updates)
- Roll back to a previous deployment
- Scale the deployment

Example Deployment manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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

### 3. Services

Services provide a stable networking endpoint to connect to Pods, which might be created and destroyed dynamically. They act as an abstraction layer that routes traffic to the appropriate Pods.

Types of Services:
- **ClusterIP**: Exposes the Service on an internal IP (default)
- **NodePort**: Exposes the Service on each Node's IP at a static port
- **LoadBalancer**: Exposes the Service externally using a cloud provider's load balancer
- **ExternalName**: Maps the Service to a DNS name

Example Service manifest:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

### 4. Namespaces

Namespaces provide a mechanism for isolating groups of resources within a single cluster. They help organize and divide cluster resources between multiple users or projects.

Default namespaces:
- **default**: For user-created resources with no namespace specified
- **kube-system**: For Kubernetes system components
- **kube-public**: For resources that should be publicly readable
- **kube-node-lease**: For node lease objects

## K3s: A Lightweight Kubernetes Distribution

For our hands-on labs, we'll be using K3s, a certified Kubernetes distribution designed for production workloads in resource-constrained environments. K3s is perfect for:

- Edge computing
- IoT devices
- CI/CD environments
- Development workstations
- ARM devices

K3s advantages:
- Single binary of less than 100MB
- Reduced memory footprint (~512MB RAM vs ~2GB for standard K8s)
- Simpler to install and operate
- Includes everything you need to run Kubernetes

## Hands-on Lab: Deploying Your First Application to Kubernetes

Let's get practical by deploying a simple web application to our K3s cluster.

### Prerequisites
- Access to a K3s cluster (Your instructor has set up a cluster at `https://k3s.thelinuxlabs.com:9443`)
- `kubectl` installed and configured to access the cluster

### Step 1: Verify Cluster Access

First, let's verify that you can access the K3s cluster:

```bash
kubectl cluster-info
kubectl get nodes
```

You should see information about the Kubernetes control plane and the available nodes.

### Step 2: Create a Namespace

Let's create a namespace for our application to keep resources organized:

```bash
kubectl create namespace my-app
```

### Step 3: Create a Deployment

Create a file named `nginx-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: my-app
spec:
  replicas: 2
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
        resources:
          limits:
            memory: "128Mi"
            cpu: "200m"
          requests:
            memory: "64Mi"
            cpu: "100m"
```

Apply the deployment:

```bash
kubectl apply -f nginx-deployment.yaml
```

### Step 4: Create a Service

Create a file named `nginx-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: my-app
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
```

Apply the service:

```bash
kubectl apply -f nginx-service.yaml
```

### Step 5: Check Your Deployment

Check that your Pods are running:

```bash
kubectl get pods -n my-app
```

Check that your Service is created:

```bash
kubectl get services -n my-app
```

### Step 6: Expose the Application

To access your application from outside the cluster, create an Ingress resource.

Create a file named `nginx-ingress.yaml` with the following content:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: my-app
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: "nginx-myusername.k3s.thelinuxlabs.com"  # Replace with your username
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```

Apply the ingress:

```bash
kubectl apply -f nginx-ingress.yaml
```

### Step 7: Access Your Application

After a few moments, you should be able to access your application at the URL specified in the Ingress resource:

```
http://nginx-myusername.k3s.thelinuxlabs.com
```

## Common kubectl Commands

Here are some essential kubectl commands to manage your Kubernetes resources:

### Viewing Resources
```bash
# List all pods in all namespaces
kubectl get pods --all-namespaces

# Get detailed information about a pod
kubectl describe pod <pod-name> -n <namespace>

# View the logs for a pod
kubectl logs <pod-name> -n <namespace>
```

### Modifying Resources
```bash
# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=3 -n <namespace>

# Delete a resource
kubectl delete -f <filename.yaml>

# Apply a manifest file
kubectl apply -f <filename.yaml>
```

### Debugging
```bash
# Execute a command in a container
kubectl exec -it <pod-name> -n <namespace> -- /bin/bash

# Check a service's endpoints
kubectl get endpoints <service-name> -n <namespace>

# Port-forward to a pod
kubectl port-forward <pod-name> 8080:80 -n <namespace>
```

## Exercise

Now that you've deployed your first application, try these exercises:

1. Scale your deployment to 3 replicas
2. Check the logs of one of your nginx pods
3. Execute a command inside one of the pods to view the content of the default Nginx page
4. Delete and recreate your deployment and service

## Summary

In this lesson, we've covered:
- The core concepts of Kubernetes
- Key components of the Kubernetes architecture
- The benefits of K3s as a lightweight Kubernetes distribution
- How to deploy a simple application to Kubernetes
- Essential kubectl commands for managing resources

In the next lesson, we'll explore how to integrate GitLab with Kubernetes to streamline your deployment process and leverage GitLab's CI/CD capabilities with Kubernetes.

## [<<Previous](../day-3/3-sast.md) &nbsp;&nbsp; [>>Next](./2-gitlab-kubernetes-integration.md) 