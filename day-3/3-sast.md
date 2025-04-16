# Securing Your Code with GitLab SAST

In our previous lessons, we built a Gatsby website, set up a CI/CD pipeline, implemented caching, and configured multiple environments. Now, let's focus on an equally important aspect of modern DevOps practices: **security**.

## What You'll Learn

- What Static Application Security Testing (SAST) is and why it matters
- How to integrate SAST scanners into your GitLab CI pipeline
- How to interpret security reports and address vulnerabilities
- How to customize security scanning for your JavaScript/React application
- Best practices for implementing "security as code"

## Introduction to SAST

Static Application Security Testing analyzes your source code without executing it to find security vulnerabilities early in the development lifecycle. This "shifting left" approach helps you:

- Identify security issues before they reach production
- Reduce the cost of fixing vulnerabilities (earlier = cheaper)
- Improve overall code quality and security awareness
- Meet compliance requirements more easily

For our Gatsby project, SAST can detect issues like:
- Insecure coding patterns
- Known vulnerable dependencies
- Cross-site scripting (XSS) opportunities
- Hardcoded secrets or credentials
- Injection vulnerabilities

## GitLab's Security Scanning Tools

GitLab provides several built-in security scanners that we can easily integrate:

| Scanner Type | What It Checks | Good For |
|--------------|----------------|----------|
| SAST | Source code for vulnerabilities | Finding coding errors that lead to security issues |
| Dependency Scanning | Project dependencies | Finding known vulnerabilities in npm packages |
| Secret Detection | Entire codebase | Finding API keys, credentials, tokens |
| Container Scanning | Docker images | Finding OS-level vulnerabilities in containers |

For our Gatsby project, we'll focus primarily on SAST and Dependency Scanning.

## Step 1: Enable GitLab SAST in Your Pipeline

The simplest way to add SAST to your pipeline is to include GitLab's pre-configured templates. Let's modify our `.gitlab-ci.yml` file:

```yaml
# At the top of your .gitlab-ci.yml file, add:
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml
```

This includes GitLab's pre-configured security scanning jobs in your pipeline.

## Step 2: Customize the Security Jobs for Our Gatsby Project

Now, let's customize these jobs to better fit our JavaScript/React project:

```yaml
# Add this to your existing .gitlab-ci.yml file

# Configure SAST for JavaScript/Node.js
sast:
  stage: test
  variables:
    SEARCH_MAX_DEPTH: 20
    SAST_EXCLUDED_PATHS: "node_modules, public, .cache"
    SAST_ANALYZER_IMAGE_TAG: 3
  rules:
    - if: $CI_COMMIT_BRANCH

# Configure Dependency Scanning
dependency_scanning:
  stage: test
  variables:
    DS_EXCLUDED_PATHS: "public, .cache"
  rules:
    - if: $CI_COMMIT_BRANCH

# Configure Secret Detection
secret_detection:
  stage: test
  variables:
    SECRET_DETECTION_HISTORIC_SCAN: "true"
  rules:
    - if: $CI_COMMIT_BRANCH
```

These configurations:
1. Set appropriate stages for our security jobs
2. Exclude unnecessary directories from scanning
3. Enable more thorough scanning options
4. Run on all branches

## Step 3: Add Security Report Artifacts

GitLab automatically generates security reports, but let's explicitly configure them:

```yaml
# For the sast job, add:
sast:
  # ... existing configuration ...
  artifacts:
    reports:
      sast: gl-sast-report.json
    paths:
      - gl-sast-report.json
    expire_in: 1 week

# For the dependency_scanning job, add:
dependency_scanning:
  # ... existing configuration ...
  artifacts:
    reports:
      dependency_scanning: gl-dependency-scanning-report.json
    paths:
      - gl-dependency-scanning-report.json
    expire_in: 1 week
```

This ensures:
1. Reports are properly categorized in GitLab's UI
2. Raw report files are available for download
3. Reports are kept for 1 week for review

## Step 4: Add Manual Security Job for Production Only

Let's add a dedicated, more thorough security scan before production deployments:

```yaml
production_security_scan:
  stage: deploy_production
  needs:
    - deploy_staging
    - test_staging
  script:
    - npm install -g @cyclonedx/bom
    - cyclonedx-bom -o bom.xml
    - npm audit --json > npm-audit.json || true
  artifacts:
    paths:
      - bom.xml
      - npm-audit.json
    expire_in: 1 month
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
  allow_failure: true
```

This job:
1. Creates a Software Bill of Materials (SBOM)
2. Runs a detailed npm audit
3. Only runs before production deployments
4. Is optional (manual trigger)

## Step 5: Update Complete Pipeline

Our complete pipeline with security scanning now looks like this:

```yaml
image: node:18

# Include GitLab security scanning templates
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml

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

# Configure SAST for JavaScript/Node.js
sast:
  stage: test
  variables:
    SEARCH_MAX_DEPTH: 20
    SAST_EXCLUDED_PATHS: "node_modules, public, .cache"
    SAST_ANALYZER_IMAGE_TAG: 3
  artifacts:
    reports:
      sast: gl-sast-report.json
    paths:
      - gl-sast-report.json
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH

# Configure Dependency Scanning
dependency_scanning:
  stage: test
  variables:
    DS_EXCLUDED_PATHS: "public, .cache"
  artifacts:
    reports:
      dependency_scanning: gl-dependency-scanning-report.json
    paths:
      - gl-dependency-scanning-report.json
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH

# Configure Secret Detection
secret_detection:
  stage: test
  variables:
    SECRET_DETECTION_HISTORIC_SCAN: "true"
  artifacts:
    reports:
      secret_detection: gl-secret-detection-report.json
    paths:
      - gl-secret-detection-report.json
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH

# Existing jobs (omitted for brevity)
# ...

# Production security scan
production_security_scan:
  stage: deploy_production
  needs:
    - deploy_staging
    - test_staging
  script:
    - npm install -g @cyclonedx/bom
    - cyclonedx-bom -o bom.xml
    - npm audit --json > npm-audit.json || true
  artifacts:
    paths:
      - bom.xml
      - npm-audit.json
    expire_in: 1 month
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: manual
  allow_failure: true

# Rest of the existing pipeline
# ...
```

## Understanding Security Reports

After running your pipeline with security scanning enabled:

1. **Navigate to Security > Vulnerability Report** in your GitLab project
2. You'll see all detected vulnerabilities categorized by severity
3. For each vulnerability, you can:
   - View detailed information about the issue
   - See the affected code/dependencies
   - Create issues to track remediation
   - Dismiss or accept the risk
   - Create merge requests to fix the issue

![Security Dashboard Screenshot](https://docs.gitlab.com/ee/user/application_security/secure_vision/img/vulnerability_report_v16_10.png)

## Common SAST Issues in JavaScript/React Applications

When running SAST on your Gatsby project, watch for these common issues:

1. **Cross-Site Scripting (XSS)**: Using `dangerouslySetInnerHTML` without proper sanitization
   ```jsx
   // Vulnerable
   <div dangerouslySetInnerHTML={{ __html: userInput }} />
   
   // Fixed
   import DOMPurify from 'dompurify';
   <div dangerouslySetInnerHTML={{ __html: DOMPurify.sanitize(userInput) }} />
   ```

2. **Hardcoded Secrets**: API keys or credentials in source code
   ```jsx
   // Vulnerable
   const API_KEY = "1234567890abcdef";
   
   // Fixed - use environment variables
   const API_KEY = process.env.GATSBY_API_KEY;
   ```

3. **Insecure Dependencies**: Using libraries with known vulnerabilities
   ```bash
   # Fix with
   npm audit fix
   # Or for major updates
   npm audit fix --force
   ```

4. **Path Traversal**: Insecure file path handling
   ```jsx
   // Vulnerable
   import(`../${userInput}/config.js`);
   
   // Fixed - whitelist approach
   const allowedModules = ['profile', 'settings', 'dashboard'];
   if (allowedModules.includes(userInput)) {
     import(`../${userInput}/config.js`);
   }
   ```

## Advanced: Custom Security Scanning

For more specialized security scanning, you can create custom jobs:

```yaml
eslint_security_scan:
  stage: test
  script:
    - npm install
    - npm install -g eslint eslint-plugin-security
    - echo '{"plugins": ["security"], "extends": ["plugin:security/recommended"]}' > .eslintrc
    - eslint --no-eslintrc -c .eslintrc --format=json src/ > eslint-security-report.json || true
  artifacts:
    paths:
      - eslint-security-report.json
    expire_in: 1 week
  needs:
    - install_dependencies
  rules:
    - if: $CI_COMMIT_BRANCH
```

This job:
1. Installs the eslint-plugin-security package
2. Creates a security-focused ESLint configuration
3. Scans your source code for security issues
4. Saves the report as an artifact

## Managing Security Policies

GitLab allows you to define security policies to automatically apply rules:

1. Create a `.gitlab/security-policies/policy.yml` file:
   ```yaml
   ---
   security-scanner-level:
     scanner: sast
     vulnerabilities:
       critical:
         action: require_approval
       high:
         action: require_approval
       medium:
         action: report
       low:
         action: report
   ```

2. This policy:
   - Requires manual approval for critical and high issues
   - Reports but allows medium and low severity issues

## Practical Exercise: Fix a Security Vulnerability

1. Run your pipeline with security scanning enabled
2. Navigate to the Security > Vulnerability Report
3. Identify an issue, preferably related to a dependency
4. Create a merge request to fix the issue:
   ```bash
   # Update dependencies to fix vulnerabilities
   npm update <vulnerable-package>
   # Or specifically install non-vulnerable version
   npm install <package>@<safe-version>
   ```
5. Verify the fix by running the pipeline again

## Benefits of Security Scanning

Implementing security scanning in your CI/CD pipeline provides:

1. **Early Detection**: Find and fix issues before they reach production
2. **Documentation**: Maintain a record of security issues and their remediation
3. **Automation**: Enforce security policies without manual review
4. **Education**: Help developers learn about security best practices
5. **Compliance**: Meet regulatory and organizational security requirements

## Best Practices for SAST Implementation

1. **Fail Builds Selectively**: 
   - Don't fail builds for low-severity issues
   - Consider manual review for medium and above

2. **Tune for Low Noise**:
   - Exclude third-party code
   - Configure appropriate rules for your project
   - Use allowlists for known false positives

3. **Progressive Implementation**:
   - Start with reports only (no failing)
   - Gradually increase strictness
   - Enforce on main branch once stable

4. **Regular Maintenance**:
   - Update scanners and rules
   - Review and refine policy
   - Track security metrics over time

## Conclusion

By integrating SAST into your GitLab CI/CD pipeline, you've added a crucial security layer to your development process. This helps you:

- Identify and fix security issues early
- Build security awareness among developers
- Create more robust applications
- Protect your users and your business

In a modern DevOps environment, security is not an afterthought but an integral part of the development process—often called "DevSecOps." The steps you've taken in this lesson move your project firmly in that direction.

## [<<Previous](./2-environments.md) &nbsp;&nbsp; [>>Next](../day-4/1-kubernetes-integration.md) 