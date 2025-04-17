# GitLab Container Registry: Storing and Managing Container Images

Before we dive into Kubernetes deployment with GitLab, it's essential to understand how to store and manage your container images. GitLab provides a built-in Container Registry that integrates seamlessly with your GitLab projects and CI/CD pipelines. This lesson will cover the fundamentals of using GitLab's Container Registry and how it serves as the foundation for your Kubernetes deployments.

## Learning Objectives

By the end of this lesson, you will:
- Understand GitLab's Container Registry and its benefits
- Learn how to configure and access the Container Registry
- Build, tag, and push Docker images to the registry
- Pull images from the registry in your Kubernetes deployments
- Implement best practices for container image management

## What is GitLab Container Registry?

GitLab Container Registry is a secure, private registry for Docker images that comes built into GitLab. It allows you to:

- Store Docker images within your GitLab project or group
- Control access to your images using GitLab permissions
- Build and push images directly from your CI/CD pipelines
- Seamlessly deploy images to Kubernetes or other environments

## Locating GitLab's Container Registry

The Container Registry is located in the left sidebar navigation under "Packages and registries":

1. Navigate to your project
2. In the left sidebar, expand "Packages and registries" through Deploy menu
3. Click on "Container Registry"

## Authentication and Access Control

To use the GitLab Container Registry, you need to authenticate with it. There are several methods:

### 1. Setting Up Personal Access Tokens

For secure authentication, especially when Two-Factor Authentication (2FA) is enabled, follow these steps:

1. Go to your user settings in GitLab (click your avatar > Edit profile > Access Tokens)
2. Create a new personal access token with a meaningful name (e.g., "Container Registry Access")
3. Select the `read_registry` and `write_registry` scopes
4. Set an expiration date if desired
5. Click "Create personal access token"
6. Copy and save the token immediately (it will only be shown once)

### 2. Logging in to the Container Registry

Once you have your personal access token, you can log in to the registry:

```bash
docker login gitlab.thelinuxlabs.com:5050
Username: your_gitlab_username
Password: your_personal_access_token
```

You should see `Login Succeeded` if authentication is successful.

### 3. Troubleshooting Login Issues

If you encounter login problems, check these common issues:

- **Firewall blocking access**: Ensure your firewall allows outgoing connections to the registry port (typically 5050 for self-hosted GitLab)
  ```bash
  # Test TCP connection to the registry
  nc -zv gitlab.thelinuxlabs.com 5050
  ```

- **Certificate issues**: For self-hosted GitLab with custom certificates:
  ```bash
  # Add certificate to Docker's trusted certificates
  sudo mkdir -p /etc/docker/certs.d/gitlab.thelinuxlabs.com:5050
  sudo cp /path/to/certificate.crt /etc/docker/certs.d/gitlab.thelinuxlabs.com:5050/ca.crt
  sudo systemctl restart docker
  ```

- **Network connectivity**: Check if you can reach the GitLab server
  ```bash
  ping gitlab.thelinuxlabs.com
  ```

- **DNS resolution**: Verify DNS resolution for the GitLab domain
  ```bash
  nslookup gitlab.thelinuxlabs.com
  ```

If you see a `Client.Timeout exceeded while awaiting headers` error, it's typically a networking issue rather than an authentication problem.

### 4. Deploy Tokens

Deploy tokens are project or group-specific tokens that aren't tied to a user:

1. Go to Settings > Repository > Deploy tokens
2. Create a token with registry read or write permissions
3. Use it to authenticate to the registry:

```bash
docker login registry.gitlab.com -u deploy-token-username -p deploy-token-password
```

### 5. CI/CD Job Token

In GitLab CI/CD pipelines, you can use predefined variables to authenticate:

```yaml
script:
  - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
```

## Building and Pushing Docker Images to the Registry

### Manually from your Local Machine

To build and push an image manually:

```bash
# Build the image
docker build -t gitlab.thelinuxlabs.com:5050/your-group/your-project/image-name:tag .

# Push to GitLab Registry
docker push gitlab.thelinuxlabs.com:5050/your-group/your-project/image-name:tag
```

### Using GitLab CI/CD

Typically, you'll build and push images through your CI/CD pipeline. Here's a basic example:

```yaml
build_and_push:
  image: docker:latest
  services:
    - docker:dind
  stage: build
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
```

This job:
1. Logs in to the GitLab Container Registry
2. Builds an image and tags it with the branch or tag name
3. Pushes the image to the registry

## Image Tagging Strategies

Effective tagging is crucial for container image management:

### 1. Branch-based Tags

```yaml
docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG .
```

This creates tags like `main`, `feature-branch`, etc.

### 2. Commit SHA Tags

```yaml
docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
```

This creates unique, immutable tags based on commit hashes.

### 3. Semantic Versioning

For releases, use semantic versioning:

```yaml
docker build -t $CI_REGISTRY_IMAGE:v1.2.3 .
```

### 4. Environment Tags

Tag images based on their target environment:

```yaml
docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG $CI_REGISTRY_IMAGE:staging
docker push $CI_REGISTRY_IMAGE:staging
```

## Using Container Registry Images in Kubernetes

Once your images are in the GitLab Container Registry, you can use them in your Kubernetes deployments:

### 1. Reference Images in Kubernetes Manifests

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      containers:
      - name: app
        image: gitlab.thelinuxlabs.com:5050/your-group/your-project/image-name:tag
```

### 2. Image Pull Authentication

Kubernetes needs authentication to pull images from private registries:

```bash
kubectl create secret docker-registry gitlab-registry \
  --docker-server=gitlab.thelinuxlabs.com:5050 \
  --docker-username=<username> \
  --docker-password=<access-token> \
  --docker-email=<email>
```

Then reference this secret in your deployment:

```yaml
spec:
  template:
    spec:
      imagePullSecrets:
      - name: gitlab-registry
      containers:
      # ...
```

### 3. Using the CI/CD Variables in Manifests

In your CI/CD pipeline, you can substitute the image details into your manifests:

```yaml
deploy_to_kubernetes:
  script:
    - sed -i "s|__IMAGE__|$CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG|g" kubernetes/deployment.yaml
    - kubectl apply -f kubernetes/deployment.yaml
```

With a template like:

```yaml
# kubernetes/deployment.yaml
spec:
  template:
    spec:
      containers:
      - name: app
        image: __IMAGE__
```

## Best Practices for Container Registry

### 1. Clean Up Old Images

Set up cleanup policies to remove old or unused images:

1. Navigate to your project's Container Registry
2. Go to the "Cleanup policy" tab
3. Configure rules based on tag, age, or name pattern

Example policy: "Remove images older than 30 days except those tagged 'latest' or matching pattern 'v*'"

### 2. Use Multi-stage Builds

Multi-stage builds create smaller, more secure images:

```Dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm ci && npm run build

# Runtime stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

### 3. Scan Images for Vulnerabilities

GitLab can automatically scan your container images for vulnerabilities:

```yaml
container_scanning:
  stage: test
  image: 
    name: registry.gitlab.com/gitlab-org/security-products/container-scanning:latest
  variables:
    CS_DEFAULT_BRANCH_IMAGE: $CI_REGISTRY_IMAGE:latest
    DOCKER_IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
    DOCKER_USER: $CI_REGISTRY_USER
    DOCKER_PASSWORD: $CI_REGISTRY_PASSWORD
  artifacts:
    reports:
      container_scanning: gl-container-scanning-report.json
```

### 4. Never Use `latest` Tag in Production

Avoid using the `latest` tag in production deployments, as it can lead to unexpected changes. Instead, use specific versions or commit hashes.

## Hands-on Exercise: Setting Up Container Registry for Your Gatsby Project

Now, let's set up the Container Registry for our Gatsby project and prepare it for Kubernetes deployment:

### Step 1: Create a Dockerfile

Create a `Dockerfile` in your Gatsby project root:

```Dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Runtime stage
FROM nginx:alpine
COPY --from=builder /app/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Step 2: Configure GitLab CI/CD to Build and Push the Image

Update your `.gitlab-ci.yml` to include a job for building and pushing the image:

```yaml
stages:
  - build
  - containerize

variables:
  DOCKER_TLS_CERTDIR: "/certs"

build_website:
  stage: build
  image: node:18
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - public/

build_and_push_image:
  stage: containerize
  image: docker:latest
  services:
    - docker:dind
  needs:
    - build_website
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG .
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
    - docker push $CI_REGISTRY_IMAGE:latest
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

### Step 3: Commit and Push Your Changes

```bash
git add Dockerfile .gitlab-ci.yml
git commit -m "Add Docker configuration for Container Registry"
git push
```

### Step 4: Verify Image in Container Registry

1. Go to your project in GitLab
2. Navigate to "Packages & Registries > Container Registry"
3. You should see your newly built image with the branch tag and `latest` tag

### Step 5: Prepare Kubernetes Deployment to Use the Image

Create a basic Kubernetes manifest that uses your image:

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gatsby-site
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gatsby-site
  template:
    metadata:
      labels:
        app: gatsby-site
    spec:
      containers:
      - name: gatsby-site
        image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_SLUG}
        ports:
        - containerPort: 80
```

In upcoming lessons, we'll expand on this foundation to deploy the application to Kubernetes.

## Common Issues and Troubleshooting

### Image Pull Errors

If Kubernetes can't pull your image, check:
- Image pull secrets are correctly configured
- The image exists in the registry
- The image tag is correct
- Network connectivity between Kubernetes and GitLab

### Authentication Issues

Common authentication problems:
- Token has expired or doesn't have registry permissions
- Incorrect username or token
- Registry path is incorrect

### Large Image Sizes

If your images are too large:
- Use multi-stage builds
- Include only necessary files (use `.dockerignore`)
- Choose smaller base images
- Remove development dependencies

## Summary

In this lesson, we've covered:
- The fundamentals of GitLab's Container Registry
- How to authenticate and access the registry
- Building and pushing images using GitLab CI/CD
- Strategies for image tagging and management
- Using registry images in Kubernetes deployments
- Best practices for container image management

GitLab's Container Registry is a powerful tool that serves as the foundation for containerized application deployment. By mastering the registry, you'll be better prepared to deploy applications to Kubernetes in the upcoming lessons.

## [<<Previous](../day-3/3-sast.md) &nbsp;&nbsp; [>>Next](./1-kubernetes-fundamentals.md) 
