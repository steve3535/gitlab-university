# Local Development and Testing

## Overview
Before setting up our CI/CD pipeline, let's verify our application works correctly in our local development environment (GitHub Codespace). This is a crucial step that helps catch issues early.

## Why Test Locally First?
- Faster feedback loop
- Easier debugging
- Save pipeline minutes
- Catch basic issues before they reach CI/CD
- Verify development environment setup

## Step-by-Step Local Development

### 1. Start Your GitHub Codespace
```bash
# Your codespace should already be connected to your GitLab repo
# Verify you're on your feature branch
git status
# Should show: On branch 1-core-task-management
```

### 2. Install Dependencies
```bash
# Install npm packages
npm install
```

### 3. Run Local Tests
```bash
# Run Jest tests
npm test

# Expected output:
# PASS tests/tasks.test.js
#   ✓ should add a new task
# Test Suites: 1 passed, 1 total
```

### 4. Start Development Server
```bash
# Start the application
npm start

# Expected output:
# TaskMaster running on port 3000
```

### 5. Test the API Endpoint
Open a new terminal in your Codespace and test the endpoint:
```bash
# Test GET /tasks endpoint
curl http://localhost:3000/tasks

# Expected output:
# []
```

## Troubleshooting Local Development

Common Issue | Solution
------------|----------
`npm install` fails | Check node version (`node -v`), should match .gitlab-ci.yml
Port already in use | Kill process using port 3000 or change port in code
Tests fail | Check test file paths and module imports
Module not found | Verify package.json dependencies and run npm install

## Best Practices for Local Development

1. 🔄 **Version Control**
   - Make small, focused commits
   - Test after each significant change
   - Use meaningful commit messages

2. 🧪 **Testing**
   - Run tests frequently
   - Add tests for new features
   - Keep test environment clean

3. 📝 **Code Organization**
   - Follow project structure
   - Keep code modular
   - Document API endpoints

## Verification Checklist
Before moving to CI/CD setup, verify:

- [ ] All dependencies install correctly
- [ ] Tests pass locally
- [ ] Application runs without errors
- [ ] API endpoints respond correctly
- [ ] No console errors or warnings
- [ ] Code is committed and pushed to GitLab

## Next Steps
Once everything works locally:
1. Set up CI/CD pipeline (next section)
2. Configure environments
3. Add deployment scripts

---
🎯 **Pro Tip**: Always verify locally before pushing to save time and pipeline minutes!
