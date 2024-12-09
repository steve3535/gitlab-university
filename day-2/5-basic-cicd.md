# Setting Up Basic CI/CD Pipeline

## 1. Create .gitignore File

First, let's create a `.gitignore` file to keep our repository clean:

```bash
# In your GitHub Codespace
touch .gitignore
```

Add these common Node.js excludes to `.gitignore`:
```
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed

# Environment variables
.env
.env.local

# IDE specific files
.idea/
.vscode/
*.swp
*.swo

# Operating System
.DS_Store
Thumbs.db
```

## 2. Create Basic CI/CD Pipeline

Create `.gitlab-ci.yml` with a simple pipeline:

```yaml
# Node version
image: node:18

# Cache dependencies
cache:
  paths:
    - node_modules/

stages:
  - test

# Simple test job
test_app:
  stage: test
  script:
    # Install dependencies
    - npm install
    # Run tests
    - npm test
```

## 3. Commit and Push Changes

```bash
# Commit .gitignore and CI configuration
git add .gitignore .gitlab-ci.yml
git commit -m "Add .gitignore and basic CI pipeline"
git push origin 1-core-task-management
```

## What This Pipeline Does

1. Uses Node.js 18 as base image
2. Caches `node_modules` to speed up builds
3. Has a single stage: `test`
4. Installs dependencies and runs tests

## Pipeline Visualization
```mermaid
graph LR
    A[Install Dependencies] --> B[Run Tests]
```

## Viewing Pipeline Results

1. Go to your GitLab repository
2. Navigate to CI/CD > Pipelines
3. You should see your pipeline running
4. Click on the pipeline to see detailed job output

## Common Issues and Solutions

Problem | Solution
--------|----------
Pipeline doesn't start | Check if .gitlab-ci.yml is valid
Tests fail in pipeline | Verify tests pass locally first
Cache not working | Check cache configuration syntax

## Next Steps
After this basic pipeline is working, we can enhance it with:
- Build stages
- Code quality checks

## Pro Tips
- 💡 Keep pipelines simple at first
- 🔍 Check pipeline logs for issues
- ⚡ Cache dependencies when possible
- 📝 Use clear job names

---
Remember: A working simple pipeline is better than a complex broken one!
