# GitLab and Kubernetes Integration

In the previous lesson, we explored the fundamentals of Kubernetes. Now, we'll learn how to integrate GitLab with Kubernetes to streamline the deployment process and leverage GitLab's CI/CD capabilities with Kubernetes.

## Learning Objectives

By the end of this lesson, you will:
- Understand the different methods for integrating GitLab with Kubernetes
- Learn about the GitLab Agent for Kubernetes (KAS)
- Connect your GitLab instance to a Kubernetes cluster
- Configure a project to deploy to Kubernetes

## GitLab's Kubernetes Integration Options

GitLab offers several ways to integrate with Kubernetes, each with its own advantages and use cases.

### 1. GitLab Agent for Kubernetes (Recommended Approach)

The GitLab Agent for Kubernetes (KAS) is GitLab's recommended way to integrate with Kubernetes clusters. It:

- **Establishes a secure connection** from the Kubernetes cluster to GitLab
- **Eliminates the need** for exposing your cluster's API
- **Supports GitOps workflows** with repository-based configuration
- **Enables features** like cluster alerts, automatic deployments, and more

### 2. Certificate-Based Integration (Legacy)

Before the Agent, GitLab used certificate-based authentication to connect to Kubernetes clusters. This approach:

- Requires your Kubernetes API to be accessible from GitLab
- Uses service accounts and tokens to authenticate
- Is considered legacy but still works for simpler setups

### 3. Custom CI/CD Scripts with kubectl

The simplest approach is to use custom CI/CD scripts with kubectl:
- Configure kubectl in your .gitlab-ci.yml
- Use kubectl commands to deploy directly
- More manual but gives you complete control

### Key Differences Between Integration Methods

| Feature | GitLab Agent | Certificate-Based | Custom kubectl |
|---------|-------------|-------------------|----------------|
| Security | Most secure | Exposes API endpoint | Varies based on implementation |
| Setup complexity | Medium | Medium | Low |
| Network requirements | Outbound only | Inbound to K8s API | Outbound only |
| GitOps support | Yes | Limited | Manual |
| Kubernetes monitoring | Yes | Yes | No |
| Maintenance overhead | Low | Medium | High |

For this course, we'll focus on the **GitLab Agent for Kubernetes** as it's the recommended approach for production environments.

## Understanding the GitLab Agent for Kubernetes

The GitLab Agent for Kubernetes (KAS) works on a reverse connectivity model:

1. The Agent is installed in your Kubernetes cluster
2. It establishes an outbound connection to GitLab
3. GitLab communicates with your cluster through this connection
4. No need to expose your Kubernetes API

### Key Components

- **Agent Server (kas)**: A component that runs in GitLab
- **Agent (agentk)**: A pod that runs in your Kubernetes cluster
- **Configuration repository**: GitLab repository that stores the agent configuration

### Benefits of Using the Agent

- **Enhanced security**: Your Kubernetes API stays private
- **Simplified network config**: Only outbound connections from your cluster to GitLab
- **GitOps workflows**: Define your deployment configurations in Git
- **CI/CD integration**: Seamlessly works with GitLab CI/CD
- **Monitoring and observability**: Access Kubernetes metrics directly in GitLab

## Hands-on Lab: Connecting GitLab to Kubernetes with the Agent

Let's set up the GitLab Agent for Kubernetes and connect our GitLab instance to our K3s cluster.

### Prerequisites

- Access to a GitLab instance with the Agent server enabled
- Access to a K3s cluster (the one from the previous lesson)
- kubectl configured to access your cluster
- A GitLab project where you'll store the agent configuration

### Step 1: Create a Configuration Repository

1. Create a new GitLab project to store your agent configuration or use an existing one
2. In the left sidebar, navigate to **Infrastructure > Kubernetes clusters**
3. Click **Connect a Kubernetes cluster** and select **Connect with Agent**
4. Fill in:
   - **Agent name**: `k3s-agent`
   - **Project**: Select your project
5. Click **Create agent**

### Step 2: Configure the Agent

After creating the agent, GitLab will provide you with instructions to download and install the agent manifest.

1. In your project, create a directory for the agent configuration:
   ```bash
   mkdir -p .gitlab/agents/k3s-agent
   ```

2. Create a basic configuration file at `.gitlab/agents/k3s-agent/config.yaml`:
   ```yaml
   ci_access:
     projects:
       - id: <your-project-path>  # e.g., group/project
   ```

3. Commit and push these changes to your repository:
   ```bash
   git add .gitlab
   git commit -m "Add Kubernetes agent configuration"
   git push
   ```

### Step 3: Install the Agent in Your Kubernetes Cluster

1. Go back to the **Infrastructure > Kubernetes clusters** page
2. Find your agent in the list and click **Details**
3. Under **Installation**, you'll see a kubectl command to install the agent
4. Copy the command and run it in your terminal:
   ```bash
   kubectl apply -f <agent-installation-url>
   ```

4. Verify the agent is running:
   ```bash
   kubectl get pods -n gitlab-kubernetes-agent
   ```

### Step 4: Verify the Connection

1. Return to GitLab and navigate to **Infrastructure > Kubernetes clusters**
2. Check that your agent shows as **Connected**
3. Click on the agent to see more details

Congratulations! Your GitLab instance is now connected to your Kubernetes cluster through the GitLab Agent.

## Using the GitLab-Kubernetes Integration

Now that the connection is established, let's explore how to use it for deployments.

### Option 1: GitOps-based Deployments

GitOps allows you to define your Kubernetes resources in Git and have them automatically applied to your cluster.

1. Create a manifest directory in your repo:
   ```bash
   mkdir -p kubernetes/manifests
   ```

2. Create a simple manifest in `kubernetes/manifests/web-app.yaml`:
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

3. Update your agent configuration in `.gitlab/agents/k3s-agent/config.yaml`:
   ```yaml
   ci_access:
     projects:
       - id: <your-project-path>
   
   gitops:
     manifest_projects:
       - id: <your-project-path>
         paths:
           - glob: 'kubernetes/manifests/*.yaml'
         default_namespace: default
   ```

4. Commit and push these changes:
   ```bash
   git add .
   git commit -m "Add Kubernetes manifests and GitOps configuration"
   git push
   ```

5. The agent will automatically apply these manifests to your cluster
6. Verify the deployment:
   ```bash
   kubectl get deployment web-app
   kubectl get service web-app-svc
   ```

### Option 2: CI/CD-based Deployments

You can also use GitLab CI/CD to deploy to your Kubernetes cluster:

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
       - kubectl apply -f kubernetes/manifests/web-app.yaml
     environment:
       name: production
       kubernetes:
         namespace: default
     rules:
       - if: $CI_COMMIT_BRANCH == "main"
   ```

2. The first time you run this pipeline, you might need to authorize the CI pipeline to access your cluster
3. Once authorized, GitLab CI will deploy your application to the Kubernetes cluster

## Advanced Configuration

### 1. Namespace Isolation

For better isolation, you can configure the agent to work with specific namespaces:

```yaml
gitops:
  manifest_projects:
    - id: <your-project-path>
      paths:
        - glob: 'kubernetes/manifests/*.yaml'
      default_namespace: project-namespace
```

### 2. Multiple Clusters

You can register multiple agents for different clusters:

```bash
# For cluster 1
mkdir -p .gitlab/agents/production-agent

# For cluster 2
mkdir -p .gitlab/agents/staging-agent
```

Each agent gets its own configuration file and can be installed on a different cluster.

### 3. Authorized Projects

You can control which projects can access your cluster:

```yaml
ci_access:
  projects:
    - id: group/project1
    - id: group/project2
```

## Common Issues and Troubleshooting

### Agent Connection Problems

If the agent isn't connecting:

1. Check the agent pod logs:
   ```bash
   kubectl logs -n gitlab-kubernetes-agent -l app=gitlab-kubernetes-agent
   ```

2. Verify network connectivity from your cluster to GitLab

3. Ensure the agent configuration is properly committed and pushed

### Permission Issues

If deployments fail due to permissions:

1. Check if the agent has the necessary RBAC permissions in the cluster
2. Verify that your CI/CD pipeline is properly authorized to use the agent
3. Check the namespace access configuration in your agent config

## Exercise

Let's practice what we've learned:

1. Connect your GitLab project to the K3s cluster using the GitLab Agent
2. Create a deployment manifest for a simple web application (use the example or create your own)
3. Configure GitOps to automatically deploy your application
4. Make a change to the manifest (e.g., increase the number of replicas) and observe it being applied
5. Add a CI/CD job that uses the agent to interact with your cluster

## Summary

In this lesson, we've covered:
- Different methods for integrating GitLab with Kubernetes
- The architecture and benefits of the GitLab Agent for Kubernetes
- Setting up the connection between GitLab and Kubernetes
- Deploying applications using GitOps and CI/CD approaches
- Advanced configurations and troubleshooting tips

In the next lesson, we'll build on this foundation and learn how to deploy our Gatsby application from previous days to our Kubernetes cluster using the GitLab-Kubernetes integration.

## [<<Previous](./1-kubernetes-fundamentals.md) &nbsp;&nbsp; [>>Next](./3-kubernetes-ci-cd.md) 