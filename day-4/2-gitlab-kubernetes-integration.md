# GitLab and Kubernetes Integration

In the previous lesson, we explored the fundamentals of Kubernetes. Now, we'll learn how to integrate GitLab with Kubernetes to streamline the deployment process and leverage GitLab's CI/CD capabilities with Kubernetes.

## Learning Objectives

By the end of this lesson, you will:
- Understand the GitLab Agent for Kubernetes (KAS)
- Connect your GitLab project to a Kubernetes cluster
- Configure a project to deploy to Kubernetes
- Learn about GitOps and CI/CD based deployment approaches

## GitLab's Kubernetes Integration

GitLab offers a modern, secure way to integrate with Kubernetes through the GitLab Agent for Kubernetes (KAS).

### GitLab Agent for Kubernetes

The GitLab Agent for Kubernetes (KAS) is GitLab's recommended way to integrate with Kubernetes clusters. It:

- **Establishes a secure connection** from the Kubernetes cluster to GitLab
- **Eliminates the need** for exposing your cluster's API
- **Supports GitOps workflows** with repository-based configuration
- **Enables features** like cluster alerts, automatic deployments, and more

### Key Benefits of Using the Agent

- **Enhanced security**: Your Kubernetes API stays private
- **Simplified network config**: Only outbound connections from your cluster to GitLab
- **GitOps workflows**: Define your deployment configurations in Git
- **CI/CD integration**: Seamlessly works with GitLab CI/CD
- **Monitoring and observability**: Access Kubernetes metrics directly in GitLab

## Understanding the Agent Architecture

The GitLab Agent for Kubernetes works on a reverse connectivity model:

1. The Agent is installed in your Kubernetes cluster
2. It establishes an outbound connection to GitLab
3. GitLab communicates with your cluster through this connection
4. No need to expose your Kubernetes API

### Key Components

- **Agent Server (kas)**: A component that runs in GitLab
- **Agent (agentk)**: A pod that runs in your Kubernetes cluster
- **Configuration repository**: GitLab repository that stores the agent configuration

## Hands-on Lab: Connecting GitLab to Kubernetes with the Agent

Let's set up the GitLab Agent for Kubernetes and connect our GitLab project to our K3s cluster using the simple UI-based approach.

### Prerequisites

- Access to a GitLab instance with the Agent server enabled
- Access to a K3s cluster (the one from the previous lesson)
- kubectl configured to access your cluster
- A GitLab project where you'll register the agent

### Step 1: Register a New Agent via the UI

1. In your GitLab project, navigate to **Infrastructure > Kubernetes clusters**
2. Click **Connect a Kubernetes cluster** and select **Connect with Agent**
3. Fill in:
   - **Agent name**: `k3s-agent-<username>` (replace `<username>` with your GitLab username)
   - **Project**: Select your current project
4. Click **Create agent**

### Step 2: Create an Empty Configuration File (Optional)

While the UI-based approach works without a configuration file, creating an empty one helps with future GitOps setup:

1. In your project, create a directory for the agent configuration:
   ```bash
   mkdir -p .gitlab/agents/k3s-agent-<username>
   ```

2. Create an empty configuration file at `.gitlab/agents/k3s-agent-<username>/config.yaml`:
   ```yaml
   # This file can be used for future GitOps configurations
   # For now, we're using the UI-based approach
   ```

3. Commit and push these changes:
   ```bash
   git add .gitlab
   git commit -m "Add empty Kubernetes agent configuration"
   git push
   ```

> **Note:** The `config.yaml` file is primarily used for GitOps workflows and advanced configurations. It allows you to version-control your agent settings, define authorized projects, and set up GitOps deployment targets. For our basic integration, the empty file is sufficient, and we'll rely on the UI-provided Helm command for installation.

### Step 3: Install the Agent in Your Kubernetes Cluster

1. After creating the agent, GitLab will display the installation instructions
2. You'll see a Helm command like this:
   ```bash
   helm repo add gitlab https://charts.gitlab.io
   helm repo update
   helm upgrade --install k3s-agent-<username> gitlab/gitlab-agent \
     --namespace gitlab-agent \
     --create-namespace \
     --set image.tag=v16.1.0 \
     --set config.token=<your-agent-token> \
     --set config.kasAddress=wss://gitlab.example.com/-/kubernetes-agent/
   ```
3. Copy the provided Helm command and run it in your terminal (make sure the agent name contains your username)
4. This will install the agent in your Kubernetes cluster

4. Verify the agent is running:
   ```bash
   kubectl get pods -n gitlab-agent | grep k3s-agent-<username>
   ```

   You should see the agent pod in a Running state.

### Step 4: Verify the Connection

1. Return to GitLab and navigate to **Infrastructure > Kubernetes clusters**
2. After a few moments, your agent should show as **Connected**
3. Click on the agent to see more details about the connection

Congratulations! Your GitLab project is now connected to your Kubernetes cluster through the GitLab Agent.

## Using the GitLab-Kubernetes Integration

Now that the connection is established, let's explore how to use it for deployments.

### Option 1: Using the Agent with CI/CD

The simplest way to use the agent is through GitLab CI/CD:

1. Add a `.gitlab-ci.yml` file to your project:
   ```yaml
   stages:
     - deploy
   
   deploy_to_kubernetes:
     stage: deploy
     image: 
       name: bitnami/kubectl:latest
       entrypoint: [""]
     script:    
       - kubectl config get-contexts
       - kubectl config use-context $CI_PROJECT_PATH:k3s-agent-<username>
       - kubectl create namespace $CI_PROJECT_NAME-$CI_PROJECT_ID --dry-run=client -o yaml | kubectl apply --validate=false -f -
       - kubectl apply --validate=false -f kubernetes/deployment.yaml -n $CI_PROJECT_NAME-$CI_PROJECT_ID
     environment:
       name: staging
     rules:
       - if: $CI_COMMIT_BRANCH == "main"
   ```

   > **Important:** Replace `<username>` with your GitLab username in the context name.

2. Create a `kubernetes/deployment.yaml` file for your application:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-app
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: web-app
     template:
       metadata:
         labels:
           app: web-app
       spec:
         containers:
         - name: web-app
           image: nginx:latest
           ports:
           - containerPort: 80
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: web-app-svc
   spec:
     selector:
       app: web-app
     ports:
     - port: 80
       targetPort: 80
     type: ClusterIP
   ```

3. Commit and push these changes:
   ```bash
   mkdir -p kubernetes
   touch kubernetes/deployment.yaml
   # Add the YAML content to deployment.yaml
   git add .
   git commit -m "Add Kubernetes deployment manifest and CI/CD configuration"
   git push
   ```

4. GitLab CI/CD will now deploy your application to the Kubernetes cluster

### Option 2: Advanced - Using GitOps with config.yaml

For more advanced setups, you can enable GitOps by updating your agent's `config.yaml`:

```yaml
gitops:
  manifest_projects:
    - id: <your-project-path>
      paths:
        - glob: 'kubernetes/*.yaml'
      default_namespace: <your-namespace>
```

With this configuration, any changes to your Kubernetes manifests will be automatically applied to your cluster.

## Troubleshooting Tips

### Agent Connection Issues

If the agent isn't connecting:

1. Check the agent pod logs:
   ```bash
   kubectl logs -n gitlab-agent -l app=gitlab-agent
   ```

2. Verify network connectivity from your cluster to GitLab

3. Check the Helm installation parameters, particularly the token and KAS address

## Exercise: Creating an Ingress for Your Application

Let's make your application accessible via a URL by creating an Ingress resource.

### Step 1: Create an Ingress Manifest

Create a file named `kubernetes/ingress.yaml` with the following content:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: "web-<username>-$CI_PROJECT_NAME.k3s.thelinuxlabs.com"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app-svc
            port:
              number: 80
```

> **Note:** Replace `<username>` with your GitLab username to create a unique hostname.

### Step 2: Update Your CI/CD Configuration

Update your `.gitlab-ci.yml` to apply the ingress manifest:

```yaml
stages:
  - deploy

deploy_to_kubernetes:
  stage: deploy
  image: 
    name: bitnami/kubectl:latest
    entrypoint: [""]
  script:    
    - kubectl config get-contexts
    - kubectl config use-context $CI_PROJECT_PATH:k3s-agent-<username>
    - kubectl create namespace $CI_PROJECT_NAME-$CI_PROJECT_ID --dry-run=client -o yaml | kubectl apply --validate=false -f -
    - kubectl apply --validate=false -f kubernetes/deployment.yaml -n $CI_PROJECT_NAME-$CI_PROJECT_ID
    - |
      INGRESS_MANIFEST=$(cat kubernetes/ingress.yaml | sed "s/<username>/$CI_USERNAME/g" | sed "s/\$CI_PROJECT_NAME/$CI_PROJECT_NAME/g")
      echo "$INGRESS_MANIFEST" | kubectl apply --validate=false -f - -n $CI_PROJECT_NAME-$CI_PROJECT_ID
    - echo "Application will be available at: https://web-$CI_USERNAME-$CI_PROJECT_NAME.k3s.thelinuxlabs.com:9443"
  environment:
    name: staging
    url: https://web-$CI_USERNAME-$CI_PROJECT_NAME.k3s.thelinuxlabs.com:9443
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

### Step 3: Add CI Variable

In your GitLab project:
1. Go to **Settings > CI/CD > Variables**
2. Add a new variable:
   - Key: `CI_USERNAME`
   - Value: Your GitLab username
   - Type: Variable
   - Environment scope: All (default)

### Step 4: Commit and Push Your Changes

```bash
# Create the ingress manifest file
cat > kubernetes/ingress.yaml << EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  annotations:
    kubernetes.io/ingress.class: "traefik"
spec:
  rules:
  - host: "web-<username>-\$CI_PROJECT_NAME.k3s.thelinuxlabs.com"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app-svc
            port:
              number: 80
EOF

# Update the placeholder with your username
sed -i "s/<username>/your-gitlab-username/g" kubernetes/ingress.yaml

# Commit and push
git add kubernetes/ingress.yaml .gitlab-ci.yml
git commit -m "Add Kubernetes ingress configuration"
git push
```

### Step 5: Verify the Deployment

1. Go to **CI/CD > Pipelines** and wait for the pipeline to complete
2. Once completed, go to **Deployments > Environments**
3. You should see your staging environment with a URL
4. Click on the URL to access your application

If everything worked correctly, you'll see the default Nginx welcome page served from your Kubernetes cluster.

## Summary

In this lesson, we've covered:
- The architecture and benefits of the GitLab Agent for Kubernetes
- Setting up the connection between GitLab and Kubernetes using the UI-based approach
- Deploying applications using CI/CD with the Kubernetes agent
- Creating an Ingress to make your application publicly accessible
- Basic troubleshooting for agent connections

In the next lesson, we'll build on this foundation and learn how to deploy our Gatsby application from previous days to our Kubernetes cluster using the GitLab-Kubernetes integration.

## [<<Previous](./1-kubernetes-fundamentals.md) &nbsp;&nbsp; [>>Next](./3-kubernetes-ci-cd.md) 