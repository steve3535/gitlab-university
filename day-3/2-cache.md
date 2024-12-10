# Optimizing GitLab CI Pipeline Performance with Caches

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
  key: "${CI_COMMIT_REF_NAME}"  # Uses branch name as cache key
  paths:
    - node_modules/             # Directory to cache
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

## Best Practices

1. **Cache Only What's Necessary:**
   ```yaml
   cache:
     paths:
       - node_modules/          # Yes: External dependencies
       # - dist/                # No: Build output
       # - .git/               # No: Repository data
   ```

2. **Use Branch-Specific Caches:**
   ```yaml
   cache:
     key: "$CI_COMMIT_REF_NAME"
     paths:
       - node_modules/
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

## Measuring Cache Impact

To evaluate cache effectiveness:
1. Note pipeline duration without cache
2. Implement caching
3. Compare pipeline durations
4. Look for:
   - Reduced dependency download time
   - Faster job execution
   - Overall pipeline speedup

## Conclusion

Caching is a powerful tool to optimize GitLab CI pipeline performance by:
- Reducing redundant downloads
- Speeding up job execution
- Preserving frequently used files

