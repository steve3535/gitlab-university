# Part 5: Setting Up GitLab CI Pipeline

Now that we have our production build working locally, let's automate this process using GitLab CI. We'll build a comprehensive pipeline step by step.

## Understanding Our Final Goal

By the end of this tutorial, we'll create a pipeline with:
- Separate stages for setup, build, and test
- Optimized artifact handling
- Multiple test jobs including security scanning
- Dependencies between jobs using the `needs` keyword

## Step 1: Create the Basic CI Pipeline Configuration

Create a new file called `.gitlab-ci.yml` in your project root with the following content:

```yaml
build_website:
  script:
    - npm install
    - npm install gatsby-cli
    - gatsby build
  artifacts:
    paths:
      - public
```

Try pushing your changes to GitLab to trigger the pipeline.

### 🚨 Common Issue #1: npm command not found

If you get `npm: command not found`, it's because our default GitLab CI image (alpine) doesn't include Node.js.

**Fix**: Update your `.gitlab-ci.yml` file to specify a Node.js image:

```yaml
image: node:18
build_website:
  tags:
    - docker
  script:
    - npm install
    - npm install gatsby-cli
    - gatsby build
  artifacts:
    paths:
      - public
```

Try pushing once again...

### 🚨 Common Issue #2: gatsby command not found

**Fix**: Modify your build script to use the local Gatsby installation:

```yaml
image: node:18
build_website:
  tags:
    - docker
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public
```

> **Hint**: To find the path to the gatsby executable, use the `find` command in your local dev environment: `find node_modules -name gatsby -type f`

## Step 2: Adding Memory Configuration

Building Gatsby sites can be memory-intensive. Let's add a variable to increase Node's memory limit:

```yaml
image: node:18
build_website:
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public
```

## Step 3: Organizing with Stages

Let's organize our pipeline into stages for better structure:

```yaml
image: node:18
stages:
  - build
  - test

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public
```

## Step 4: Adding Basic Tests

Let's add testing to ensure our build is correct:

```yaml
image: node:18
stages:
  - build
  - test

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public

test_artifact:
  stage: test
  image: alpine
  tags:
    - docker
  script:
    - grep -q "Gatsby" ./public/index.html

test_website:
  stage: test
  tags:
    - docker
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby serve &
    - sleep 5
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
```

💡 **Key Concepts**:
- Jobs in the same stage (like both test jobs) run in parallel
- Using `&` makes gatsby serve run in background
- The `sleep 5` gives the server time to start
- The `-q` flag makes grep quiet for cleaner logs

## Step 5: Optimizing the Pipeline with Setup Stage

Let's optimize our pipeline by adding a setup stage and using job dependencies:

```yaml
image: node:18
stages:
  - setup
  - build
  - test

install_dependencies:
  stage: setup
  tags:
    - docker
  script:
    - npm install
  artifacts:
    paths:
      - node_modules/.bin/
      - node_modules/gatsby/
    expire_in: 1 hour

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies

test_artifact:
  stage: test
  tags:
    - docker
  image: alpine
  script:
    - pwd
    - ls
    - grep -q "Gatsby" public/index.html
  needs:
    - build_website

test_website:
  stage: test
  tags:
    - docker
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby serve &
    - sleep 10
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
  needs:
    - install_dependencies
    - build_website
```

💡 **Optimization Notes**:
- The `install_dependencies` job only runs once and passes node_modules to dependent jobs
- We use `needs` to specify job dependencies explicitly
- Setting `expire_in: 1 hour` for temporary artifacts helps manage storage
- We extended the `sleep` time from 5 to 10 seconds to give the server more startup time

## Step 6: Adding Security Scanning

Let's add a security scan job to check for vulnerabilities in our dependencies:

```yaml
image: node:18
stages:
  - setup
  - build
  - test

install_dependencies:
  stage: setup
  tags:
    - docker
  script:
    - npm install
  artifacts:
    paths:
      - node_modules/.bin/
      - node_modules/gatsby/
    expire_in: 1 hour

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies

test_artifact:
  stage: test
  tags:
    - docker
  image: alpine
  script:
    - pwd
    - ls
    - grep -q "Gatsby" public/index.html
  needs:
    - build_website

test_website:
  stage: test
  tags:
    - docker
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby serve &
    - sleep 10
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
  needs:
    - install_dependencies
    - build_website

security_scan:
  stage: test
  tags:
    - docker
  script:
    - npm audit --omit=dev --json > vulnerabilities-report.json || true
  artifacts:
    paths:
      - vulnerabilities-report.json
    expire_in: 1 week
  needs:
    - install_dependencies
    - build_website
  allow_failure: true
```

💡 **Security Scan Notes**:
- We use `npm audit` to check for vulnerabilities
- The `|| true` ensures the job doesn't fail if vulnerabilities are found
- We save the report as an artifact that expires after 1 week
- `allow_failure: true` means the pipeline continues even if this job fails

## Viewing Pipeline Results

1. Navigate to CI/CD > Pipelines in your GitLab project
2. Click on the latest pipeline to see all jobs
3. Click on any job to see detailed logs
4. For the build job:
   - Find the "Artifacts" section on the right
   - Click "Browse" to see the built website files
   - Download artifacts to inspect locally if needed
5. For the security scan:
   - Download the vulnerabilities report to review potential issues

## Pipeline Optimization Tips

- **Job Dependencies**: Using `needs` instead of stage dependencies allows for more flexible pipelines
- **Artifact Management**: Only save what's needed and set appropriate expiration times
- **Resource Efficiency**: Use lightweight images like `alpine` for simple test jobs
- **Parallel Jobs**: Take advantage of parallel execution in the same stage
- **Error Handling**: Use `allow_failure` for non-critical jobs like security scanning
- **Cache Usage**: Consider using cache for dependencies that don't change often (not shown in this example)

## 🚨 Common Issues and Solutions

1. **Timeout Issues**
   - Jobs have a 1-hour default timeout
   - Use the cancel button if a job hangs

2. **Parallel Pipelines**
   - New commits trigger new pipelines
   - Previous pipelines continue running
   - Cancel old pipelines manually if needed

3. **Resource Limitations**
   - If pipelines are slow, check if your GitLab runners have enough resources
   - Consider using smaller Docker images where possible

## [<<Previous](./5-static-website-1.md) &nbsp;&nbsp; [>>Next](./8-static-website-deploy.md)
