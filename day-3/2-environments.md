# Deploying to Multiple Environments with GitLab CI/CD

In our previous lessons, we built a Gatsby website, set up a basic CI/CD pipeline, added version tracking, and optimized performance with caching. Now, let's take our deployment strategy to the next level by implementing multiple environments.

## What You'll Learn

- What environments are in GitLab CI/CD and why they're valuable
- How to configure staging and production environments
- How to implement deployment rules based on branches
- How to view and manage environments in GitLab
- Which environment features are available in different GitLab tiers (CE vs. Premium/Ultimate)

## Introduction to GitLab Environments

In GitLab, an environment represents a deployment target for your application, such as development, staging, or production. Environments help you:

- Track what code is deployed where
- Keep your deployment process consistent
- Enable easy rollbacks to previous versions
- Manage different configurations across environments

Currently, our Gatsby site deploys directly to a single Surge domain. Let's enhance our deployment strategy by creating dedicated staging and production environments.

## The Problem: Single-Environment Deployment

Our current deploy job from the previous lesson looks like this:

```yaml
deploy_to_surge:
  stage: deploy
  script:
    - npm install --global surge
    - surge --project ./public --domain your-chosen-name.surge.sh
  needs:
    - build_website
    - test_artifact
    - test_website
```

This approach has several limitations:

1. We can't test deployment changes before going to production
2. We can't have separate configurations for different environments
3. We have no way to verify a staging deployment before promoting to production
4. We're missing GitLab's environment tracking features

## Step 1: Reorganizing Pipeline Stages

First, let's reorganize our pipeline stages to better represent our deployment workflow:

```yaml
stages:
  - setup
  - build
  - test
  - deploy_staging
  - deploy_production
```

This structure makes it clear that:
- Deployment happens in two separate stages
- Production deployment comes after staging
- Tests must pass before any deployment

## Step 2: Creating a Staging Environment

Now, let's create a staging environment by updating our deploy job:

```yaml
deploy_staging:
  stage: deploy_staging
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain ${CI_PROJECT_NAME}-staging.surge.sh
  environment:
    name: staging
    url: https://${CI_PROJECT_NAME}-staging.surge.sh
  needs:
    - build_website
    - test_website
```

Key changes:
1. We renamed the job to `deploy_staging`
2. We changed the stage to `deploy_staging`
3. We're using a different domain for staging (`-staging` suffix)
4. We added the `environment` configuration with:
   - `name`: Identifies the environment in GitLab
   - `url`: Provides a clickable link in the GitLab UI
5. We added `tags: docker` to ensure the job runs on Docker-capable runners

## Step 3: Adding a Production Environment

Next, let's add a production deployment job:

```yaml
deploy_production:
  stage: deploy_production
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain ${CI_PROJECT_NAME}.surge.sh
  environment:
    name: production
    url: https://${CI_PROJECT_NAME}.surge.sh
  needs:
    - deploy_staging
  when: manual
```

Key features:
1. Separate `deploy_production` stage
2. Production uses a "clean" domain without `-staging`
3. Production deployment requires the staging deployment to complete first
4. `when: manual` means this job requires manual intervention to run
5. The `environment` section defines the production environment
6. We added `tags: docker` to ensure the job runs on Docker-capable runners

## Step 4: Using Variables to Avoid Duplication

To make our configuration more maintainable, let's use variables for the domain names:

```yaml
variables:
  STAGING_DOMAIN: "${CI_PROJECT_NAME}-staging.surge.sh"
  PRODUCTION_DOMAIN: "${CI_PROJECT_NAME}.surge.sh"

# Then in the jobs:
deploy_staging:
  # ...
  script:
    - npm install --global surge
    - surge --project ./public --domain $STAGING_DOMAIN
  environment:
    name: staging
    url: https://$STAGING_DOMAIN

deploy_production:
  # ...
  script:
    - npm install --global surge
    - surge --project ./public --domain $PRODUCTION_DOMAIN
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN
```

## Step 5: Implementing Deployment Rules Based on Branches

Let's improve our workflow by automatically deploying to staging from the `main` branch and allowing production deployments only from `main`:

```yaml
deploy_staging:
  # ... other configuration ...
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy_production:
  # ... other configuration ...
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

These rules ensure:
1. Staging deploys automatically when changes are pushed to `main`
2. Production deployment is available but requires manual approval
3. Neither job runs for other branches

## Step 6: Adding Environment-Specific Tests

Let's add a verification step for each environment:

```yaml
test_staging:
  stage: deploy_staging
  tags:
    - docker
  script:
    - curl -s https://$STAGING_DOMAIN | grep -q "Gatsby"
  needs:
    - deploy_staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: on_success

test_production:
  stage: deploy_production
  tags:
    - docker
  script:
    - curl -s https://$PRODUCTION_DOMAIN | grep -q "Gatsby"
  needs:
    - deploy_production
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: on_success
```

These jobs:
1. Verify that the deployment was successful
2. Ensure our website contains expected content
3. Run automatically after their respective deployments (with `when: on_success`)
4. Only run when the deployment jobs run
5. Use Docker-capable runners with `tags: docker`

## Step 7: Complete Pipeline Configuration

Let's put everything together into our complete pipeline:

```yaml
image: node:18

stages:
  - setup
  - build
  - test
  - deploy_staging
  - deploy_production

variables:
  STAGING_DOMAIN: "${CI_PROJECT_NAME}-staging.surge.sh"
  PRODUCTION_DOMAIN: "${CI_PROJECT_NAME}.surge.sh"

# Cache configuration
cache:
  key:
    files:
      - package-lock.json
    prefix: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .cache/

install_dependencies:
  stage: setup
  tags:
    - docker
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"
  script:
    # Version environment variables
    - export GATSBY_VERSION=${CI_COMMIT_SHORT_SHA}
    - export GATSBY_BUILD_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    - export GATSBY_BRANCH=${CI_COMMIT_BRANCH}
    - export GATSBY_COMMIT_URL=${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}
    
    # Build website
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies

test_website:
  stage: test
  tags:
    - docker
  script:
    - ./node_modules/.bin/gatsby serve &
    - sleep 10
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
  needs:
    - build_website

deploy_staging:
  stage: deploy_staging
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain $STAGING_DOMAIN
  environment:
    name: staging
    url: https://$STAGING_DOMAIN
  needs:
    - build_website
    - test_website
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

test_staging:
  stage: deploy_staging
  tags:
    - docker
  script:
    - curl -s https://$STAGING_DOMAIN | grep -q "Gatsby"
  needs:
    - deploy_staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: on_success

deploy_production:
  stage: deploy_production
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain $PRODUCTION_DOMAIN
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN
  needs:
    - deploy_staging
    - test_staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual

test_production:
  stage: deploy_production
  tags:
    - docker
  script:
    - curl -s https://$PRODUCTION_DOMAIN | grep -q "Gatsby"
  needs:
    - deploy_production
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: on_success
```

## Understanding GitLab Environments in Detail

Now that we've set up our environments, let's explore how they work in GitLab:

### Environment Types

GitLab supports two types of environments:

1. **Static Environments**: These have fixed names (like our "staging" and "production") and are reused across deployments. They're perfect for persistent environments like production.

2. **Dynamic Environments**: These have names generated from variables (like `review/${CI_COMMIT_REF_SLUG}`). They're ideal for temporary environments like feature branch previews.

### Environment States

Environments can be in one of three states:

1. **Available**: The environment is active and accessible.
2. **Stopping**: The environment is being deleted/stopped.
3. **Stopped**: The environment has been deactivated.

## Viewing Environments in GitLab

To see your environments:

1. Go to your project in GitLab
2. Navigate to **Operate > Environments** from the left sidebar
3. You'll see a list of all environments with:
   - The environment name
   - Deployment status
   - Last deployed commit
   - A direct link to the environment URL
   - Action buttons (re-deploy, stop, etc.)

## Advanced Environment Features

### 1. Environment Protection **(PREMIUM FEATURE)**

> **Note**: This feature is only available in GitLab Premium and Ultimate tiers, not in Community Edition.

In GitLab Premium, you can protect sensitive environments to restrict who can deploy to them:

1. Go to **Settings > CI/CD > Protected environments**
2. Click **Add protected environment**
3. Select the environment (e.g., "production")
4. Choose which roles can deploy to it

This ensures only authorized team members can trigger production deployments.

### 2. Environment-Specific Variables 

You can set variables that only apply to specific environments:

1. Go to **Settings > CI/CD > Variables**
2. Add a variable (e.g., `API_URL`)
3. Under **Environment scope**, choose the environment (e.g., "production")
4. Save the variable

Now this variable will only be available in the specified environment's jobs.

### 3. Manual Deployments and Approvals

As we've implemented with `when: manual`, you can require manual approval before deploying to sensitive environments. This creates a promotion workflow where:

1. Code is automatically deployed to staging
2. Someone reviews the staging deployment
3. They manually approve the production deployment
4. The code is promoted to production

### 4. Rollbacks **(SOME FEATURES PREMIUM)**

GitLab makes it easy to roll back to previous deployments:

1. Go to **Operate > Environments**
2. Click on an environment (e.g., "production")
3. Find a previous deployment in the history
4. Click the "Re-deploy" button (circular arrow)

> **Note**: Advanced rollback features like automatic rollbacks on failure require GitLab Premium.

## Practical Exercise: Implementing Review Apps

Review apps are dynamically created environments for feature branches, allowing you to preview changes before merging.

### Step 1: Create a Feature Branch

First, create a feature branch to test our review apps setup:

```bash
# Make sure you're up-to-date with main
git checkout main
git pull

# Create a new feature branch
git checkout -b feature/homepage-redesign

# Make some changes to the homepage
# For example, edit src/pages/index.js or change the color scheme in src/components/layout.css

# Commit and push your changes
git add .
git commit -m "Redesign homepage header [ci skip]"
git push -u origin feature/homepage-redesign
```

### Step 2: Add Review Apps Configuration

Now, add the following configuration to your `.gitlab-ci.yml` file:

```yaml
# Add this to your existing pipeline
deploy_review:
  stage: deploy_staging
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain ${CI_PROJECT_NAME}-${CI_COMMIT_REF_SLUG}.surge.sh
  environment:
    name: review/${CI_COMMIT_REF_SLUG}
    url: https://${CI_PROJECT_NAME}-${CI_COMMIT_REF_SLUG}.surge.sh
    on_stop: stop_review
  needs:
    - build_website
    - test_website
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE == "push"

stop_review:
  stage: deploy_staging
  tags:
    - docker
  script:
    - npm install --global surge
    - surge teardown ${CI_PROJECT_NAME}-${CI_COMMIT_REF_SLUG}.surge.sh
  environment:
    name: review/${CI_COMMIT_REF_SLUG}
    action: stop
  needs: []
  rules:
    - if: $CI_COMMIT_BRANCH != "main" && $CI_PIPELINE_SOURCE == "push"
      when: manual
```

### Step 3: Test the Review App

1. After pushing your feature branch, GitLab will automatically trigger a pipeline
2. The `deploy_review` job will create a unique environment for your branch
3. Once the pipeline completes, go to **Operate > Environments** 
4. You should see a review environment with the name of your branch
5. Click on the URL to visit your feature branch's deployed version
6. Make additional changes to your branch and push them to see updates

This configuration:
1. Creates a unique environment for each branch
2. Uses the branch name in the environment name and URL
3. Adds a job to stop/delete the environment when needed
4. Only runs for non-main branches

## GitLab Community Edition (CE) vs. Premium Features

For educational purposes, here's a summary of environment features available in different GitLab tiers:

| Feature | Community Edition (CE) | Premium/Ultimate |
|---------|------------------------|-----------------|
| Basic environment tracking | ✅ | ✅ |
| Deployment history | ✅ | ✅ |
| Manual deployments | ✅ | ✅ |
| Environment variables | ✅ | ✅ |
| Review apps | ✅ | ✅ |
| Protected environments | ❌ | ✅ |
| Advanced environment dashboards | ❌ | ✅ |
| Environment type/tier | ❌ | ✅ |
| Auto rollback | ❌ | ✅ |

While protected environments require Premium or Ultimate, you can still implement a similar workflow in CE by using:
- Branch protection rules to limit who can merge to main
- Manual approval steps with `when: manual`
- Strict code review processes

## Benefits of Multiple Environments

Implementing multiple environments offers numerous advantages:

1. **Safer Deployments**: Test changes in staging before going to production
2. **Better Quality Control**: Review each environment before promoting
3. **Isolated Testing**: Test features in isolation without affecting production
4. **Predictable Promotion**: Clear path from staging to production
5. **Deployment Tracking**: See what's deployed where and when
6. **Faster Feedback**: Get feedback on features before they reach production
7. **Easy Rollbacks**: Quickly recover from problematic deployments

## Conclusion

By implementing multiple environments in our Gatsby project, we've created a robust deployment pipeline that:
- Automatically deploys to staging for continuous integration
- Requires manual approval for production deployments
- Creates isolated environments for feature branches
- Gives us full visibility into our deployment history

This approach significantly improves our workflow by ensuring changes are thoroughly tested before reaching production and giving us tools to monitor and manage our deployments.

## [<<Previous](./1-cache.md) &nbsp;&nbsp; [>>Next](./3-sast.md)
