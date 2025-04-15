# Optimizing GitLab CI Pipeline Performance with Caching

## Introduction to Caching in GitLab CI

In CI/CD pipelines, every job typically starts with a clean environment, which means dependencies must be downloaded repeatedly. This can significantly slow down your pipelines. Caching solves this problem by preserving specific directories between jobs and pipeline runs.

### Why Caching Matters

Without caching:
- Each job downloads the same dependencies
- Build times are longer than necessary
- External bandwidth is wasted
- Developers wait longer for feedback

With caching:
- Dependencies are reused between pipeline runs
- Build times are significantly reduced
- Less bandwidth is consumed
- Faster feedback loops for developers

## Understanding the Need for Caching

### The Clean Environment Challenge

- Every job starts with a fresh Docker image
- Only repository code is available
- No dependencies from previous jobs are preserved
- External dependencies must be downloaded each time
- Common example: `npm install` downloading node modules repeatedly

### What to Cache?

Ideal candidates for caching are:
- External project dependencies not stored in Git
- Downloaded packages and modules
- Build artifacts that are reused between jobs
- Any frequently accessed but rarely changed files

## Implementing Cache in GitLab CI

### Basic Cache Configuration

```yaml
cache:
  key: "${CI_COMMIT_REF_NAME}" # Uses branch name as cache key
  paths:
    - node_modules/ # Directory to cache
```

### Job-Level vs Global Cache

#### Job-Level Cache

```yaml
build_website:
  script:
    - npm install
    - npm run build
  cache:
    key: "${CI_COMMIT_REF_NAME}"
    paths:
      - node_modules/
```

#### Global Cache (Recommended for Shared Dependencies)

```yaml
# Global cache configuration
cache:
  key: "${CI_COMMIT_REF_NAME}"
  paths:
    - node_modules/

build_website:
  script:
    - npm install
    - npm run build

test_website:
  script:
    - npm install
    - npm test
```

## How Caching Works

### Cache Process Flow

1. **Before Job Execution:**
   - GitLab checks for existing cache using the specified key
   - If found, downloads and extracts the cache
   - If not found, starts with empty directories

2. **During Job Execution:**
   - Job runs with cached files available
   - Any changes to cached directories are tracked

3. **After Job Completion:**
   - Modified cached directories are compressed
   - Cache is uploaded for future jobs

### Cache Keys

- Use dynamic keys based on variables like:
  - Branch name: `${CI_COMMIT_REF_NAME}`
  - Commit SHA: `${CI_COMMIT_SHA}`
  - Project path: `${CI_PROJECT_PATH}`
  - Files content: Using the `files:` keyword

#### Cache Key Examples

```yaml
# Branch-specific cache (default)
cache:
  key: ${CI_COMMIT_REF_NAME}
  paths:
    - node_modules/

# Per-job unique cache
cache:
  key: ${CI_JOB_NAME}-${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/

# Project-wide shared cache
cache:
  key: global-cache-key
  paths:
    - node_modules/
    
# Cache with version control (change version to invalidate)
cache:
  key: ${CI_COMMIT_REF_NAME}-v1
  paths:
    - node_modules/

# Including package.json hash in cache key
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/
```

## Advanced Caching Strategies

### 1. Cache Fallback Strategy

When you need a fallback mechanism if a specific cache isn't found:

```yaml
cache:
  key: 
    files:
      - package-lock.json
    prefix: ${CI_COMMIT_REF_SLUG}
  fallback_keys:
    - default-node-modules
  paths:
    - node_modules/
```

### 2. Using Cache Policy for Fine Control

```yaml
build_app:
  stage: build
  cache:
    key: ${CI_COMMIT_REF_NAME}
    paths:
      - node_modules/
    policy: pull-push  # default: both pull and push to cache
  script:
    - npm install
    - npm run build

lint_code:
  stage: test
  cache:
    key: ${CI_COMMIT_REF_NAME}
    paths:
      - node_modules/
    policy: pull  # only pull from cache, don't update it
  script:
    - npm run lint
```

## Best Practices

### 1. Cache Only What's Necessary

```yaml
cache:
  paths:
    - node_modules/ # Yes: External dependencies
    # - dist/ # No: Build output
    # - .git/ # No: Repository data
```

### 2. Use Branch-Specific Caches

```yaml
cache:
  key: "$CI_COMMIT_REF_NAME"
  paths:
    - node_modules/
```

### 3. Cache Size vs. Performance Balance

- Large caches take longer to download/upload
- Consider separating large dependency directories into multiple caches
- Periodically review and prune obsolete caches

### 4. Cache vs. Artifacts

| Cache | Artifacts |
|-------|-----------|
| Meant for dependencies | Meant for build outputs |
| Used between jobs | Used between stages and for downloads |
| Automatically managed | Explicitly attached to jobs |
| Persists between pipelines | Only available in current pipeline |

## Complete Practical Example with K3s Deployment

Here's a comprehensive example that demonstrates real-world caching with deployment to K3s:

```yaml
stages:
  - setup
  - test
  - build
  - deploy

variables:
  NODE_VERSION: 16
  IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
  KUBE_NAMESPACE: demo-app

# Global cache configuration - shared across all jobs
cache:
  key:
    files:
      - package-lock.json
    prefix: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
  
install_dependencies:
  stage: setup
  image: node:${NODE_VERSION}
  script:
    - echo "Installing dependencies with cache optimization..."
    - npm ci  # Faster and more reliable than npm install for CI environments
  # Default policy is pull-push (both download and update the cache)

lint_and_test:
  stage: test
  image: node:${NODE_VERSION}
  cache:
    # Use same key but only pull from cache, don't update it
    policy: pull
  script:
    - echo "Linting code..."
    - npm run lint
    - echo "Running tests..."
    - npm test

build_app:
  stage: build
  image: node:${NODE_VERSION}
  cache:
    policy: pull
  script:
    - echo "Building application..."
    - npm run build
    - echo "Building Docker image..."
    - docker build -t $IMAGE_TAG .
    - docker push $IMAGE_TAG
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  only:
    - main
    - staging

deploy_to_k3s:
  stage: deploy
  image: 
    name: bitnami/kubectl:latest
    entrypoint: [""]
  cache: {}  # Disable cache for this job as we don't need node_modules
  before_script:
    - echo "$KUBE_CONFIG" | base64 -d > kubeconfig.yaml
    - export KUBECONFIG="$PWD/kubeconfig.yaml"
  script:
    - echo "Deploying to K3s cluster..."
    - kubectl create namespace $KUBE_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: demo-app
        namespace: $KUBE_NAMESPACE
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: demo-app
        template:
          metadata:
            labels:
              app: demo-app
          spec:
            containers:
            - name: demo-app
              image: $IMAGE_TAG
              ports:
              - containerPort: 80
      EOF
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: v1
      kind: Service
      metadata:
        name: demo-app
        namespace: $KUBE_NAMESPACE
      spec:
        ports:
        - port: 80
          targetPort: 80
        selector:
          app: demo-app
      EOF
    - |
      cat <<EOF | kubectl apply -f -
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: demo-app
        namespace: $KUBE_NAMESPACE
        annotations:
          kubernetes.io/ingress.class: traefik
      spec:
        rules:
        - host: demo-app.k3s.thelinuxlabs.com
          http:
            paths:
            - path: /
              pathType: Prefix
              backend:
                service:
                  name: demo-app
                  port:
                    number: 80
      EOF
    - kubectl rollout status deployment/demo-app -n $KUBE_NAMESPACE
  environment:
    name: production
    url: https://demo-app.k3s.thelinuxlabs.com:9443
  only:
    - main
```

## Troubleshooting Cache Issues

### Clearing Runner Caches

If cache causes unexpected issues:
1. Go to **Settings > CI/CD**
2. Click **Clear Runner Caches**
3. Run pipeline again with fresh cache

### Common Cache Problems

1. **Cache Not Being Used:**
   - Verify cache key matches
   - Check paths are correct
   - Ensure runner has cache enabled

2. **Stale Cache:**
   - Use more specific cache keys
   - Clear runner caches
   - Add cache version to key

3. **Debugging Cache Usage:**
   ```yaml
   job_name:
     script:
       - echo "Current directory: $PWD"
       - ls -la  # List all files including hidden ones
       - ls -la node_modules || echo "node_modules directory not found"
       - du -sh node_modules 2>/dev/null || echo "Cannot check size - directory not found"
   ```

## Measuring Cache Impact

To evaluate cache effectiveness:
1. Note pipeline duration without cache
2. Implement caching
3. Compare pipeline durations
4. Look for:
   - Reduced dependency download time
   - Faster job execution
   - Overall pipeline speedup

### Example Performance Improvements

| Configuration | Total Duration | Dependencies Installation | Improvement |
|---------------|----------------|---------------------------|-------------|
| No Cache      | 115s           | 45s                       | -           |
| Basic Cache   | 73s            | 10s                       | 36.5%       |
| Optimized Cache | 63s          | 5s                        | 45.2%       |

## Hands-On Lab Exercise

### Create a Basic Project

1. Create a new GitLab repository
2. Initialize a simple Node.js project with the following files:

**package.json**
```json
{
  "name": "caching-demo",
  "version": "1.0.0",
  "description": "GitLab CI Caching Demo",
  "main": "index.js",
  "scripts": {
    "test": "jest",
    "lint": "eslint .",
    "build": "echo 'Building project...' && mkdir -p dist && cp -r src/* dist/"
  },
  "dependencies": {
    "express": "^4.17.1"
  },
  "devDependencies": {
    "eslint": "^8.2.0",
    "jest": "^27.3.1"
  }
}
```

**src/index.js**
```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello GitLab CI!');
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});

module.exports = app;
```

**src/app.test.js**
```javascript
const app = require('./index');

test('App exists', () => {
  expect(app).toBeDefined();
});
```

### Create Initial Pipeline Without Caching

```yaml
stages:
  - setup
  - lint
  - test
  - build

variables:
  NODE_VERSION: 16

install_dependencies:
  stage: setup
  image: node:${NODE_VERSION}
  script:
    - npm install
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

lint_code:
  stage: lint
  image: node:${NODE_VERSION}
  script:
    - npm install
    - npm run lint

run_tests:
  stage: test
  image: node:${NODE_VERSION}
  script:
    - npm install
    - npm test

build_app:
  stage: build
  image: node:${NODE_VERSION}
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 day
```

### Implement Caching Solution

Modify your `.gitlab-ci.yml` to implement caching:

```yaml
stages:
  - setup
  - lint
  - test
  - build

variables:
  NODE_VERSION: 16

# Global cache configuration
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/

install_dependencies:
  stage: setup
  image: node:${NODE_VERSION}
  script:
    - npm ci

lint_code:
  stage: lint
  image: node:${NODE_VERSION}
  script:
    - npm run lint
  cache:
    policy: pull

run_tests:
  stage: test
  image: node:${NODE_VERSION}
  script:
    - npm test
  cache:
    policy: pull

build_app:
  stage: build
  image: node:${NODE_VERSION}
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 day
  cache:
    policy: pull
```

## Conclusion

Caching is a powerful tool to optimize GitLab CI pipeline performance by:
- Reducing redundant downloads
- Speeding up job execution
- Preserving frequently used files
- Providing faster feedback to developers

By implementing effective caching strategies, you can significantly reduce pipeline execution time and improve the overall efficiency of your CI/CD workflow.