# Optimizing GitLab CI Pipeline Performance with Caching

In our Gatsby website project, you may have noticed that each pipeline run repeatedly downloads all Node.js dependencies. This redundant work makes our pipelines slower than necessary. Let's fix that using GitLab CI's caching mechanism.

## What You'll Learn

- Why caching is important in CI pipelines
- How to implement caching for your Gatsby project
- Best practices for effective cache management
- How to measure the performance improvement

## Understanding the Problem

Let's first understand why we need caching:

### The Clean Environment Challenge

Each GitLab CI job runs in a completely isolated environment:

- Every job starts with a fresh Docker container
- Only your repository code is initially available
- Dependencies from previous jobs/pipelines aren't preserved
- External dependencies (like npm packages) must be downloaded every time
- For our Gatsby site, this means running `npm install` for every pipeline

Let's examine our current pipeline from the previous lesson:

```yaml
build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"
  script:
    - npm install gatsby-cli
    
    # Environment variables for version display
    - export GATSBY_VERSION=${CI_COMMIT_SHORT_SHA}
    - export GATSBY_BUILD_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    - export GATSBY_BRANCH=${CI_COMMIT_BRANCH}
    - export GATSBY_COMMIT_URL=${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}
    
    # Run Gatsby build
    - ./node_modules/.bin/gatsby build
    
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies
```

## What Should We Cache?

The ideal candidates for caching are files that:

1. Are **expensive to generate or download** (like node_modules)
2. **Don't change frequently** between pipeline runs
3. Are **not already in your repository**
4. Are **needed by multiple jobs or future pipelines**

For our Gatsby project, these are prime caching candidates:
- `node_modules/` directory (npm dependencies)
- `.cache/` directory (Gatsby's build cache)

## Step 1: Implementing Basic Caching

Let's update our `.gitlab-ci.yml` file to include cache configuration:

```yaml
# Global cache configuration
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .cache/

# Rest of your pipeline configuration...
```

This simple change tells GitLab to:
1. Save the contents of `node_modules/` and `.cache/` directories after a job completes
2. Restore these directories when a new job starts
3. Use the branch name as the cache key, so each branch has its own cache

## Step 2: Updating Our Pipeline with Caching
### Important:
* we dont have any central cache such as a database or a S3 bucket. The cache is not *distributed*: the cache scope is the runner, i.e. each runner manages a its own cache.
  Henceforth, when tagging our pipeline jobs, we should ensure to use consistently the same runner.  
* while using cache, we can avoid using artifacts for external dependencies.  
* wile using cache, jobs within the same stage have a mutual exclusive access to the cache.  
  
Let's integrate caching into our full Gatsby pipeline:

```yaml
image: node:18

stages:
  - setup
  - build
  - test
  - deploy

# Global cache configuration
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .cache/

install_dependencies:
  stage: setup
  tags:
    - docker1
  script:
    - npm install
  # artifacts:
  #  paths:
      # - node_modules/.bin/
      # - node_modules/gatsby/
    # expire_in: 1 hour

build_website:
  stage: build
  tags:
    - docker1
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"
  script:
    - export GATSBY_VERSION=${CI_COMMIT_SHORT_SHA}
    - export GATSBY_BUILD_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    - export GATSBY_BRANCH=${CI_COMMIT_BRANCH}
    - export GATSBY_COMMIT_URL=${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies

test_artifact:
  stage: test
  image: alpine
  tags:
    - docker1
  script:
    - grep -q "Gatsby" ./public/index.html
  needs:
    - build_website

test_website:
  stage: test
  tags:
    - docker1
  script:
    - ls -l ./node_modules 
    #- npm install
    #- npm install gatsby-cli
    - ./node_modules/.bin/gatsby serve &
    - sleep 5
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
  needs:
    - install_dependencies
    - build_website
    - test_artifact

security_scan:
  stage: test
  tags:
    - docker1
  script:
    - npm audit --omit=dev --json > vulnerabilities-report.json || true
  artifacts:
    paths:
      - vulnerabilities-report.json
    expire_in: 1 week
  needs:
    - install_dependencies
    - build_website
    - test_website
  allow_failure: true

deploy_to_surge:
  stage: deploy
  tags:
    - docker1
  script:
    - npm install --global surge
    - surge --project ./public --domain your-chosen-name.surge.sh
  needs:
    - test_website
  environment:
    name: staging
    url: https://your-chosen-name.surge.sh
```

## How GitLab Caching Works

Understanding how caching works will help you use it effectively:

### The Cache Lifecycle

1. **Before Job Execution:**
   - GitLab checks for existing cache based on the key
   - If found, it downloads and extracts the cache to the proper locations
   - If not found, it starts with empty directories

2. **During Job Execution:**
   - Your job runs with access to the cached files
   - Any changes to the cached directories are tracked

3. **After Job Completion:**
   - Modified cached directories are compressed into an archive
   - This archive is uploaded to GitLab's cache storage
   - The cache becomes available for future jobs

### Cache Key Strategies

The cache key determines which cache is used. Here are some strategies:

1. **Branch-specific caching** (recommended for most cases):
   ```yaml
   cache:
     key: ${CI_COMMIT_REF_SLUG}  # Uses branch name (slugified)
     paths:
       - node_modules/
   ```

2. **Global caching** (shared across all branches):
   ```yaml
   cache:
     key: global-cache-key
     paths:
       - node_modules/
   ```

3. **Per-job caching** (useful for job-specific dependencies):
   ```yaml
   job_name:
     script: ...
     cache:
       key: job-specific-cache
       paths:
         - some-directory/
   ```

4. **Fallback caching** (tries branch cache first, then falls back to default):
   ```yaml
   cache:
     key:
       files:
         - package-lock.json
       prefix: ${CI_COMMIT_REF_SLUG}
     paths:
       - node_modules/
   ```

## Step 3: Advanced Caching Techniques for Our Project

Let's enhance our caching strategy for the Gatsby project:

```yaml
# This is a better cache configuration for our Gatsby project
cache:
  key:
    files:
      - package-lock.json  # Cache changes when dependencies change
    prefix: ${CI_COMMIT_REF_SLUG}  # Different cache per branch
  paths:
    - node_modules/
    - .cache/
  policy: pull-push  # Both download and upload cache
```

This improved configuration:
1. Includes the `package-lock.json` file's hash in the cache key
2. Creates a new cache whenever dependencies change
3. Maintains separate caches for each branch
4. Explicitly sets the cache policy to both pull and push

## Performance Comparison

To demonstrate the impact of caching, let's compare pipeline durations:

| Pipeline Step | Without Cache | With Cache | Improvement |
|---------------|--------------|------------|-------------|
| npm install   | ~2 minutes   | ~15 seconds| ~87% faster |
| Gatsby build  | ~90 seconds  | ~45 seconds| ~50% faster |
| Total pipeline| ~4 minutes   | ~2 minutes | ~50% faster |

*Note: Actual times will vary based on project size and runner performance*

## Best Practices

1. **Cache Only What's Necessary:**
   ```yaml
   cache:
     paths:
       - node_modules/          # Yes: External dependencies
       # - dist/                # No: Build output (use artifacts instead)
       # - .git/               # No: Repository data
   ```

2. **Use Artifacts for Build Outputs:**
   - Cache is for inputs (dependencies)
   - Artifacts are for outputs (build results)

3. **Include Lock Files in Cache Key:**
   ```yaml
   cache:
     key:
       files:
         - package-lock.json    # Changes when dependencies change
   ```

4. **Consider Cache Size:**
   - Large caches (>100MB) may slow down your pipeline
   - Be selective about what you cache

5. **Use Different Cache Keys for Different Branches:**
   - Prevents cache conflicts between branches
   - Isolates experimental work

## Troubleshooting Cache Issues

### Clearing Runner Caches

If a cache becomes corrupted or causes issues:

1. Go to **Settings > CI/CD**
2. Expand the **Pipeline Settings** section
3. Click **Clear Runner Caches**
4. Run your pipeline again with a fresh cache

### Common Cache Problems

1. **Cache Not Being Used:**
   - Check if cache paths exist at the end of the job
   - Verify cache key matches expected value
   - Examine job logs for cache download messages

2. **Stale Cache:**
   - Use more specific cache keys (include dependency file hashes)
   - Clear runner caches manually
   - Add a version number to your cache key

3. **Slow Pipeline Despite Caching:**
   - Cache may be too large
   - Runner might have slow network or disk
   - Consider distributed caching if available

## Advanced Topic: Cache vs. Artifacts

It's important to understand the difference between caching and artifacts:

| Feature       | Cache                  | Artifacts                |
|---------------|------------------------|--------------------------|
| **Purpose**   | Speed up future runs   | Save job outputs         |
| **Lifetime**  | Persistent (until key changes) | Temporary (configurable) |
| **Visibility**| Not browsable          | Browsable in UI          |
| **Usage**     | Input to jobs          | Output from jobs         |
| **Example**   | node_modules           | built website (public/)  |

In our Gatsby project:
- **Cache** the `node_modules/` and `.cache/` directories
- Use **artifacts** for the `public/` directory

## Practical Exercise: Measure Your Improvement

1. Run your pipeline without caching and note the duration
2. Implement caching as shown above
3. Run the pipeline again and compare the duration
4. Check the job logs for cache download/upload messages

## Conclusion

Caching is a powerful technique that can dramatically improve your CI/CD pipeline performance. By properly caching dependencies like node_modules, you can:

- Reduce pipeline execution time
- Save bandwidth and resources
- Improve developer experience
- Speed up your deployment process

In the next lesson, we'll explore how to set up different environments in GitLab CI/CD to streamline your deployment workflow.

## [<<Previous](./0-gitlab-predefined-variables.md) &nbsp;&nbsp; [>>Next](./2-environments.md)

