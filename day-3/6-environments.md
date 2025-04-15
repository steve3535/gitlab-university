# GitLab Environments: Deploy to Multiple Targets

Environments in GitLab represent deployment targets for your application, such as development, staging, or production. They help you track what code is deployed where, maintain consistent deployment processes, and manage different configurations across your software lifecycle.

## Learning Objectives

- Understand what GitLab environments are and why they're valuable
- Configure multiple environments in a GitLab CI/CD pipeline
- Deploy a simple application to different environments
- View and manage deployments in the GitLab UI

## Prerequisites

- Access to a GitLab account
- A new or existing GitLab project

## Creating a Project in GitLab

1. Log in to your GitLab account
2. Navigate to your dashboard (if not already there)
3. Click on **New project** and select **Create blank project**
4. Fill in the project details:
   - Name: `gitlab-environments-demo`
   - Project slug: will be auto-filled
   - Project description (optional): "A demo of GitLab environments"
   - Visibility Level: Choose "Public" for this exercise
5. Click **Create project**

## Creating Application Files in the Web UI

Let's create a simple Node.js Express application to demonstrate environments. We'll create all files directly in GitLab's web UI.

### 1. Creating app.js

1. In your project, navigate to the **Repository** section
2. Click on the **+** dropdown and select **New file**
3. For the filename, enter `app.js`
4. Copy and paste the following code:

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello from ${process.env.ENVIRONMENT || 'unknown'} environment!</h1>
    <p>Version: ${process.env.CI_COMMIT_SHORT_SHA || 'local'}</p>
    <p>Deployed at: ${new Date().toISOString()}</p>
  `);
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
```

5. Commit message: "Add app.js file"
6. Click **Commit changes**

### 2. Creating package.json

1. Click on the **+** dropdown and select **New file**
2. For the filename, enter `package.json`
3. Copy and paste the following code:

```json
{
  "name": "gitlab-environments-demo",
  "version": "1.0.0",
  "description": "Demo for GitLab environments",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

4. Commit message: "Add package.json file"
5. Click **Commit changes**

### 3. Creating Dockerfile

1. Click on the **+** dropdown and select **New file**
2. For the filename, enter `Dockerfile`
3. Copy and paste the following code:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

4. Commit message: "Add Dockerfile"
5. Click **Commit changes**

### 4. Creating .gitlab-ci.yml

1. Click on the **+** dropdown and select **New file**
2. For the filename, enter `.gitlab-ci.yml`
3. Copy and paste the following code:

```yaml
stages:
  - build
  - test
  - deploy-dev
  - deploy-staging
  - deploy-production

variables:
  DOCKER_REGISTRY: "${CI_REGISTRY_IMAGE}"
  KUBERNETES_NAMESPACE: gitlab-demo

build:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $DOCKER_REGISTRY:$CI_COMMIT_SHORT_SHA .
    - docker push $DOCKER_REGISTRY:$CI_COMMIT_SHORT_SHA
  rules:
    - if: $CI_COMMIT_BRANCH

test:
  stage: test
  image: node:18-alpine
  script:
    - npm install
    - echo "Running tests..."
    # In a real scenario, you would run actual tests here
    - exit 0
  rules:
    - if: $CI_COMMIT_BRANCH

.deploy_template: &deploy_definition
  image: bitnami/kubectl:latest
  script:
    - echo "Deploying to $ENVIRONMENT environment..."
    - kubectl config set-cluster k3s --server=$KUBE_URL --insecure-skip-tls-verify=true
    - kubectl config set-credentials gitlab --token=$KUBE_TOKEN
    - kubectl config set-context default --cluster=k3s --user=gitlab
    - kubectl config use-context default
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: demo-app-$ENVIRONMENT
        namespace: $KUBERNETES_NAMESPACE
        labels:
          app: demo-app
          environment: $ENVIRONMENT
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: demo-app
            environment: $ENVIRONMENT
        template:
          metadata:
            labels:
              app: demo-app
              environment: $ENVIRONMENT
          spec:
            containers:
            - name: demo-app
              image: $DOCKER_REGISTRY:$CI_COMMIT_SHORT_SHA
              ports:
              - containerPort: 3000
              env:
              - name: ENVIRONMENT
                value: "$ENVIRONMENT"
              - name: CI_COMMIT_SHORT_SHA
                value: "$CI_COMMIT_SHORT_SHA"
      EOF
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: v1
      kind: Service
      metadata:
        name: demo-app-$ENVIRONMENT
        namespace: $KUBERNETES_NAMESPACE
      spec:
        selector:
          app: demo-app
          environment: $ENVIRONMENT
        ports:
        - port: 80
          targetPort: 3000
      EOF
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: demo-app-$ENVIRONMENT
        namespace: $KUBERNETES_NAMESPACE
        annotations:
          kubernetes.io/ingress.class: traefik
      spec:
        rules:
        - host: "$ENVIRONMENT.demo.k3s.thelinuxlabs.com"
          http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: demo-app-$ENVIRONMENT
                  port:
                    number: 80
      EOF

deploy-dev:
  <<: *deploy_definition
  stage: deploy-dev
  variables:
    ENVIRONMENT: dev
  environment:
    name: dev
    url: https://dev.demo.k3s.thelinuxlabs.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

deploy-staging:
  <<: *deploy_definition
  stage: deploy-staging
  variables:
    ENVIRONMENT: staging
  environment:
    name: staging
    url: https://staging.demo.k3s.thelinuxlabs.com
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy-production:
  <<: *deploy_definition
  stage: deploy-production
  variables:
    ENVIRONMENT: production
  environment:
    name: production
    url: https://production.demo.k3s.thelinuxlabs.com
  when: manual
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

4. Commit message: "Add GitLab CI/CD configuration with environments"
5. Click **Commit changes**

### 5. Creating README.md

1. Click on the **+** dropdown and select **New file**
2. For the filename, enter `README.md`
3. Copy and paste the following content:

```markdown
# GitLab Environments Demo

This is a simple Node.js application used to demonstrate GitLab Environments.

## GitLab CI/CD

This project includes a `.gitlab-ci.yml` configuration that:

1. Builds a Docker image
2. Runs tests
3. Deploys to three environments:
   - Development (automatic when pushing to `develop` branch)
   - Staging (automatic when pushing to `main` branch)
   - Production (manual trigger from `main` branch)

## Environments

You can view all environments in GitLab by navigating to **Operate > Environments**.

Each environment has its own URL:
- Dev: https://dev.demo.k3s.thelinuxlabs.com
- Staging: https://staging.demo.k3s.thelinuxlabs.com
- Production: https://production.demo.k3s.thelinuxlabs.com
```

4. Commit message: "Add README.md"
5. Click **Commit changes**

## Setting Up CI/CD Variables

For the pipeline to work correctly, you need to configure the necessary CI/CD variables:

1. Go to **Settings > CI/CD** in your project
2. Expand the **Variables** section
3. Click **Add variable** and add the following:

   a. First variable:
   - Key: `KUBE_URL`
   - Value: `https://k3s.thelinuxlabs.com:9443`
   - Type: Variable
   - Environment scope: All (default)
   - Protect variable: No
   - Mask variable: No
   
   b. Second variable:
   - Key: `KUBE_TOKEN`
   - Value: *[Get this value from your instructor]*
   - Type: Variable
   - Environment scope: All (default)
   - Protect variable: Yes
   - Mask variable: Yes
   
   c. Third variable:
   - Key: `KUBERNETES_NAMESPACE`
   - Value: `gitlab-demo`
   - Type: Variable
   - Environment scope: All (default)
   - Protect variable: No
   - Mask variable: No

4. Click **Save variables**

## Creating a Develop Branch

To trigger the dev environment deployment:

1. Go to your project's **Repository** section
2. Click on the branch dropdown (default is "main")
3. Enter "develop" as the new branch name
4. Click **Create branch**

## Understanding the Environment Configuration

Let's break down the key components of our pipeline:

1. **Stages**: We've defined 5 stages that represent our pipeline flow from build to production deployment.

2. **Build Job**: Builds and pushes a Docker image to the GitLab registry.

3. **Test Job**: Runs tests on our application (simplified for this demo).

4. **Deploy Template**: A reusable template for deployment to different environments.

5. **Environment-specific Jobs**: Three deployment jobs for dev, staging, and production environments.

6. **Environment Configuration**:
   ```yaml
   environment:
     name: staging
     url: https://staging.demo.k3s.thelinuxlabs.com
   ```
   This tells GitLab that the job deploys to a specific environment, and provides a direct link to access the deployed application.

7. **Rules**: Control when each job runs based on the branch name:
   - `develop` branch deploys to dev
   - `main` branch deploys to staging
   - `main` branch can be manually deployed to production

## Types of Environments in GitLab

In GitLab, environments can be either:

1. **Static Environments**: Reused by successive deployments with static names (like our dev, staging, and production).

2. **Dynamic Environments**: Usually created and destroyed for each deployment (like review apps for merge requests).

## Viewing Environments in GitLab

Once you've run your pipeline, you can view your environments:

1. Navigate to **Operate > Environments** in your project's sidebar
2. Here you'll see all your environments with:
   - The latest deployed version
   - When it was deployed
   - A direct link to the environment URL
   - Status of the environment

## Environment Benefits

Using environments in GitLab provides several benefits:

1. **Deployment Tracking**: Know exactly what version is deployed where
2. **Deployment History**: See a history of all deployments to each environment
3. **Rollback Capability**: Easily redeploy a previous version if needed
4. **Environment-specific Variables**: Maintain different configurations for each environment
5. **Deployment Approvals**: Require approvals before deploying to sensitive environments
6. **Protection**: Protect critical environments (like production) from unauthorized deployments

## Advanced Environment Features

GitLab environments support advanced features including:

1. **Auto Stop**: Automatically stop environments after a certain time period
2. **Review Apps**: Create dynamic environments for each merge request
3. **Auto Rollback**: Automatically roll back deployments when monitoring alerts are triggered
4. **Deployment Tiers**: Organize environments into tiers (development, testing, production)

## Practice Exercise

Now that you've set up the environments, follow these steps to see them in action:

1. Make a change to the application on the `develop` branch:
   - Go to the repository and navigate to `app.js`
   - Click **Edit** and change the greeting message
   - Commit the changes to the `develop` branch

2. Watch the pipeline run:
   - Go to **CI/CD > Pipelines**
   - Watch the pipeline stages progress
   - Observe the deployment to the dev environment

3. Create a merge request:
   - Go to **Merge requests > New merge request**
   - Set source branch as `develop` and target branch as `main`
   - Create the merge request with a title like "Update greeting message"

4. Merge the changes:
   - Once the merge request is ready, click **Merge**
   - Go to **CI/CD > Pipelines** and watch the pipeline run
   - Observe the deployment to the staging environment

5. Deploy to production:
   - Find the pipeline that deployed to staging
   - Click on the manual action button (play icon) for the production deployment
   - Confirm the deployment

6. View your environments:
   - Go to **Operate > Environments**
   - See all three environments listed
   - Click on the environment URLs to visit each deployed application
   - Observe the differences in the displayed environment name and version

## Conclusion

GitLab environments provide a powerful way to manage and track your deployments across different targets. By implementing this pattern, you gain visibility, control, and consistency in your deployment process.

In this lesson, you've learned how to:
- Configure multiple environments in GitLab CI/CD
- Deploy a simple application to different environments
- Use branch-based rules to determine deployment targets
- View and manage environments in the GitLab UI

## Practice Exercise

1. Create a branch called `develop` in your repository
2. Make a small change to the application
3. Push the change and watch it deploy to the dev environment
4. Create a merge request to merge `develop` into `main`
5. After merging, observe the deployment to the staging environment
6. Manually trigger the production deployment
7. Visit the GitLab Environments page to see all your deployments 