# Setting Up CI/CD Pipeline and Environments

## Overview
In this section, we'll set up a simple but effective CI/CD pipeline for our TaskMaster app. We'll learn how code moves through different stages and environments, just like in real-world projects.

## Prerequisites
- GitHub Codespace connected to your GitLab repository
- Your feature branch (`1-core-task-management`) from previous section
- Basic understanding of YAML syntax

## Learning Objectives
- Create a basic CI/CD pipeline
- Understand different pipeline stages
- Set up multiple environments
- Learn about code verification and testing
- Deploy to different environments

## Step-by-Step Instructions

### 1. Create Basic Project Structure

In your GitHub Codespace, create this minimal project structure:

```
taskmaster/
├── .gitlab-ci.yml
├── package.json
├── src/
│   ├── index.js
│   └── tasks.js
└── tests/
    └── tasks.test.js

mkdir -p src tests
touch .gitlab-ci.yml package.json src/index.js src/tasks.js tests/tasks.test.js

```

### 2. Create Package.json

Create a simple `package.json`:

```json
{
  "name": "taskmaster",
  "version": "1.0.0",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest",
    "build": "echo 'Simulating build...'"
  },
  "dependencies": {
    "express": "^4.17.1"
  },
  "devDependencies": {
    "jest": "^27.0.6"
  }
}
```

### 3. Create Basic Application Code

In `src/index.js`:
```javascript
const express = require('express');
const app = express();
const tasks = require('./tasks');

app.use(express.json());

app.get('/tasks', (req, res) => {
  res.json(tasks.getAllTasks());
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`TaskMaster running on port ${port}`);
});
```

In `src/tasks.js`:
```javascript
let tasks = [];

module.exports = {
  getAllTasks() {
    return tasks;
  },
  addTask(task) {
    tasks.push(task);
    return task;
  }
};
```

### 4. Add a Simple Test

In `tests/tasks.test.js`:
```javascript
const tasks = require('../src/tasks');

test('should add a new task', () => {
  const task = { id: 1, title: 'Test Task' };
  tasks.addTask(task);
  expect(tasks.getAllTasks()).toContainEqual(task);
});
```

### 5. Create GitLab CI/CD Pipeline

Create `.gitlab-ci.yml`:

```yaml
stages:
  - build
  - test
  - deploy

variables:
  NODE_VERSION: "18"

# Cache dependencies between jobs
cache:
  paths:
    - node_modules/

# Build Stage
build:
  stage: build
  image: node:${NODE_VERSION}
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - node_modules/
      - src/

# Test Stage
test:
  stage: test
  image: node:${NODE_VERSION}
  script:
    - npm test
  dependencies:
    - build

# Deploy to Different Environments
deploy_staging:
  stage: deploy
  script:
    - echo "Deploying to staging..."
  environment:
    name: staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy_production:
  stage: deploy
  script:
    - echo "Deploying to production..."
  environment:
    name: production
  rules:
    - if: $CI_COMMIT_TAG
  when: manual
```

### 6. Commit and Push Changes

In your GitHub Codespace:
```bash
git add .
git commit -m "Set up basic CI/CD pipeline with environments"
git push origin 1-core-task-management
```

## Understanding the Pipeline

### Pipeline Stages
1. **Build**: Installs dependencies and prepares application
2. **Test**: Runs automated tests to verify code
3. **Deploy**: Pushes code to different environments

### Environments
- **Staging**: Automatic deployment when code is merged to main
- **Production**: Manual deployment only when a tag is created

## Best Practices

1. 🔄 **Pipeline Structure**
   - Keep stages simple and focused
   - Use caching to speed up builds
   - Include only necessary files in artifacts

2. 🚀 **Deployment**
   - Always deploy to staging first
   - Require manual approval for production
   - Use environment-specific variables

3. ✅ **Testing**
   - Write meaningful tests
   - Keep test execution time reasonable
   - Fix failing tests before merging

## Common Issues and Solutions

Problem | Solution
--------|----------
Pipeline fails on install | Check node_modules cache and npm registry access
Tests timeout | Increase test timeout in jest configuration
Deploy fails | Verify environment variables and deployment credentials

## Pro Tips
- 💡 Monitor pipeline execution times
- 🔍 Use pipeline visualizations in GitLab UI
- 📝 Keep build logs for troubleshooting
- 🚦 Pay attention to test coverage

## What's Next?
- Add more comprehensive tests
- Implement actual deployment scripts
- Configure environment variables
- Add code quality checks
