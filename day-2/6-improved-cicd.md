# Code Verification Stage

## Overview
Let's enhance our pipeline to properly verify our code. We'll focus on:
- Building our code (though minimal in our case)
- Running automated tests
- Checking code quality

## Update .gitlab-ci.yml

```yaml
# Base image
image: node:18

include:
  - template: Code-Quality.gitlab-ci.yml  # Include the template properly

# Define verification stages
stages:
  - build
  - test
  - code_quality  # Match the stage name from Code Quality template

# Cache for efficiency
cache:
  paths:
    - node_modules/

# Build stage
build_job:
  stage: build
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - node_modules/
      - build/

# Automated tests with JUnit report
test_job:
  stage: test
  script:
    - npm test
  artifacts:
    when: always
    reports:
      junit: junit.xml  # We'll need to configure Jest to output JUnit format
  dependencies:
    - build_job

# The code_quality job is now automatically included from the template
# We don't need to define it manually
```

## Configure Jest for JUnit Reports

Update your `package.json` to add Jest JUnit reporter:

```bash
npm install --save-dev jest-junit
```

Then update the Jest configuration in `package.json`:
```json
{
  "scripts": {
    "test": "jest --ci --reporters=default --reporters=jest-junit"
  },
  "jest": {
    "testEnvironment": "node",
    "reporters": [
      "default",
      "jest-junit"
    ]
  },
  "jest-junit": {
    "outputDirectory": ".",
    "outputName": "junit.xml",
    "suiteName": "TaskMaster Tests",
    "classNameTemplate": "{filepath}",
    "titleTemplate": "{title}",
    "ancestorSeparator": " › "
  }
}
```

## What Changed
1. Properly included Code Quality template
2. Added JUnit test reporting
3. Removed manual code_quality job definition (it's provided by the template)
4. Kept stages and jobs organized clearly

## Commit the changes and push the code
```bash
git commit -am 'improved ci yaml'
git push
```

## Viewing Results

### Test Reports
- Navigate to your pipeline
- Check the Tests tab for detailed test results
- Download Artifacts to see the json report

### Code Quality Reports
- Automatically appears in merge requests
- Shows code quality changes
- Highlights new issues

## Pro Tips
- 💡 Check pipeline status in GitLab UI to verify configuration
- 🔍 Use the CI Lint tool to validate .gitlab-ci.yml
- ⚡ Keep test reports for debugging failures
- 📝 Review Code Quality reports in merge requests

## Next Steps
After verification passes:
1. Review any Code Quality issues
2. Fix identified problems
3. Maintain or improve test coverage
4. Prepare for the security stage

---
Remember: Good verification catches issues early in the development cycle!
