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

## Prerequisites Setup

### 1. Install kubectl

For Ubuntu/Debian Linux:
```bash
# Add Kubernetes apt repository
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubectl
sudo apt-get update
sudo apt-get install -y kubectl
```

For other operating systems, follow the instructions at: https://kubernetes.io/docs/tasks/tools/install-kubectl/

Verify installation:
```bash
kubectl version --client
```

### 2. Configure Cluster Access

Access to the Kubernetes cluster is managed through a dedicated GitLab project called `kubeadmin`.

1. Navigate to the `kubeadmin` project in GitLab
2. Go to **Settings > CI/CD > Variables**
3. Find the variable named `KUBE_CONFIG`
4. Copy the content of this variable (it's your kubeconfig file)

5. Create your kubectl config directory:
```bash
mkdir -p ~/.kube
```

6. Paste the kubeconfig content into your config file:
```bash
cat > ~/.kube/config << EOF
[PASTE THE KUBE_CONFIG CONTENT HERE]
EOF
chmod 600 ~/.kube/config
```

7. Verify your access:
```bash
kubectl cluster-info
kubectl get nodes
```

Expected output should show the cluster running at `https://k3s.thelinuxlabs.com:9443`

### 3. Understanding Your Access

As a student, you have access to:
- Create and manage resources in your assigned namespace
- View cluster-wide resources like nodes and namespaces

## Hands-on Lab: Deploying Your First Application to Kubernetes

Let's deploy a simple web application to our K3s cluster.

### Step 1: Verify Cluster Access

First, let's verify that you can access the cluster:

```bash
kubectl cluster-info
kubectl get nodes
```

You should see information about the Kubernetes control plane and the available nodes.

### Step 2: Create Your Personal Namespace

To avoid conflicts with other students, create a namespace with your GitLab username:

```bash
# Replace <username> with your GitLab username
kubectl create namespace my-app-<username>
```

Verify your namespace was created:
```bash
kubectl get namespace my-app-<username>
```

### Step 3: Create a Deployment

Create a file named `nginx-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: my-app-<username>  # Replace <username> with your GitLab username
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
kubectl apply -f nginx-deployment.yaml -n my-app-<username>
```

### Step 4: Create a Service

Create a file named `nginx-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: my-app-<username>  # Replace <username> with your GitLab username
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
kubectl apply -f nginx-service.yaml -n my-app-<username>
```

### Step 5: Check Your Deployment

Check that your Pods are running:

```bash
kubectl get pods -n my-app-<username>
```

Check that your Service is created:

```bash
kubectl get services -n my-app-<username>
```

### Step 6: Expose the Application

To access your application from outside the cluster, create an Ingress resource.

Create a file named `nginx-ingress.yaml` with the following content:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  namespace: my-app-<username>  # Replace <username> with your GitLab username
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: "nginx-<username>.k3s.thelinuxlabs.com"  # Replace <username> with your GitLab username
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
kubectl apply -f nginx-ingress.yaml -n my-app-<username>
```

### Step 7: Access Your Application

After a few moments, you should be able to access your application at the URL:

```
https://nginx-<username>.k3s.thelinuxlabs.com:9443
```

Replace `<username>` with your GitLab username.

## Common kubectl Commands

Here are some essential kubectl commands to manage your Kubernetes resources:

### Viewing Resources
```bash
# Get resources in your namespace
kubectl get pods -n my-app-<username>
kubectl get services -n my-app-<username>
kubectl get deployments -n my-app-<username>

# Get detailed information about a pod
kubectl describe pod <pod-name> -n my-app-<username>

# View the logs for a pod
kubectl logs <pod-name> -n my-app-<username>
```

### Modifying Resources
```bash
# Scale a deployment
kubectl scale deployment nginx-deployment --replicas=3 -n my-app-<username>

# Delete a resource
kubectl delete -f <filename.yaml> -n my-app-<username>

# Apply a manifest file
kubectl apply -f <filename.yaml> -n my-app-<username>
```

### Debugging
```bash
# Execute a command in a container
kubectl exec -it <pod-name> -n my-app-<username> -- /bin/bash

# Check a service's endpoints
kubectl get endpoints nginx-service -n my-app-<username>

# Port-forward to a pod
kubectl port-forward <pod-name> 8080:80 -n my-app-<username>
```

## Exercise

Now that you've deployed your first application, try these guided exercises:

### Exercise 1: Customize Your Nginx Homepage

Let's modify your Nginx deployment to display a personalized welcome page with your username.

#### Step 1: Create a Custom HTML File

First, create a file named `index.html` with custom content:

```bash
cat << EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Kubernetes</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 40px;
            background-color: #f5f5f5;
            color: #333;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #0066cc;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .highlight {
            background-color: #e6f7ff;
            padding: 15px;
            border-left: 4px solid #0066cc;
            margin: 20px 0;
        }
        .footer {
            margin-top: 30px;
            font-size: 0.8em;
            color: #666;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Kubernetes!</h1>
        
        <div class="highlight">
            <h2>Hello, <username>!</h2>
            <p>This page is being served from a Kubernetes pod in your namespace.</p>
        </div>
        
        <p>Congratulations on deploying your first application to Kubernetes. This page 
        demonstrates how to use ConfigMaps to customize content served by your pods.</p>
        
        <p>Some things you've learned:</p>
        <ul>
            <li>Creating namespaces for resource isolation</li>
            <li>Deploying applications using Deployments</li>
            <li>Exposing applications with Services</li>
            <li>Making applications accessible via Ingress</li>
            <li>Using ConfigMaps to customize application content</li>
        </ul>
        
        <div class="footer">
            GitLab University Kubernetes Training - Deployed by <username>
        </div>
    </div>
</body>
</html>
EOF
```
Then, substitute the placeholder with your username:  
```
# Replace <username> with your username
sed -i "s/<username>/<your_username>/g" index.html
```

#### Step 2: Create a ConfigMap from the HTML File

Now, create a ConfigMap containing your HTML file:

```bash
kubectl create configmap nginx-index-html --from-file=index.html -n my-app-<username>
```

Verify the ConfigMap was created:

```bash
kubectl get configmap nginx-index-html -n my-app-<username>
```

You can also check its contents:

```bash
kubectl describe configmap nginx-index-html -n my-app-<username>
```

#### Step 3: Update Your Deployment to Use the ConfigMap

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: my-app-<username>  # Replace <username> with your GitLab username
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
        volumeMounts:
        - name: nginx-index-html
          mountPath: /usr/share/nginx/html/
        resources:
          limits:
            memory: "128Mi"
            cpu: "200m"
          requests:
            memory: "64Mi"
            cpu: "100m"
      volumes:
      - name: nginx-index-html
        configMap:
          name: nginx-index-html
```

Apply the updated deployment:

```bash
kubectl apply -f nginx-deployment.yaml -n my-app-<username>
```

#### Step 4: Verify the Deployment

Check that your pods are restarting with the new configuration:

```bash
kubectl get pods -n my-app-<username>
```

Wait for the pods to be in a Running state, then access your application to see the custom page:

```
https://nginx-<username>.k3s.thelinuxlabs.com:9443
```

You should see your personalized welcome page with your GitLab username.

### Exercise 2: Scale Your Deployment

Try scaling your deployment to 3 replicas:

```bash
kubectl scale deployment nginx-deployment --replicas=3 -n my-app-<username>
```

Verify the number of pods increased:

```bash
kubectl get pods -n my-app-<username>
```

### Exercise 3: Explore Pod Details

Check the logs of one of your Nginx pods:

```bash
# Get the pod name first
kubectl get pods -n my-app-<username>

# View logs for a specific pod (replace <pod-name> with an actual pod name)
kubectl logs <pod-name> -n my-app-<username>
```

Execute a command inside one of the pods to view the content of your custom index.html file:

```bash
# Replace <pod-name> with an actual pod name
kubectl exec -it <pod-name> -n my-app-<username> -- cat /usr/share/nginx/html/index.html
```

## Summary

In this lesson, we've covered:
- The core concepts of Kubernetes
- Key components of the Kubernetes architecture
- The benefits of K3s as a lightweight Kubernetes distribution
- How to deploy a simple application to Kubernetes
- Customizing content using ConfigMaps
- Essential kubectl commands for managing resources

In the next lesson, we'll explore how to integrate GitLab with Kubernetes to streamline your deployment process and leverage GitLab's CI/CD capabilities with Kubernetes.

## [<<Previous](../day-3/3-sast.md) &nbsp;&nbsp; [>>Next](./2-gitlab-kubernetes-integration.md) 
