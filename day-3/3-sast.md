# Securing Your Code with GitLab CI/CD Security Scanners

In our previous lessons, we built a Gatsby website, set up a CI/CD pipeline, implemented caching, and configured multiple environments. Now, let's add an essential layer to our DevOps workflow: security scanning.

## What You'll Learn

- How to implement four different security scanners in your GitLab CI pipeline
- How to configure each scanner for optimal results
- How to review and interpret security findings
- How to fix common security issues in a JavaScript/React application

## Introduction to GitLab Security Scanners

For our Gatsby project, we'll add four security scanners to our pipeline:

1. **Static Application Security Testing (SAST)**: Analyzes source code for security vulnerabilities
2. **Secret Detection**: Identifies credentials and other secrets committed to your repository
3. **Dependency Scanning**: Checks for known vulnerabilities in your project dependencies
4. **Container Scanning**: Scans container images for OS-level vulnerabilities (if you're using Docker)

Let's implement them one by one.

## Adding SAST to the Pipeline

Adding a GitLab security scanner to your pipeline is straightforward. To enable SAST for our Gatsby project, we need to include a GitLab-provided template in our `.gitlab-ci.yml` file.

1. Open your `.gitlab-ci.yml` file
2. Add this line to the top of the file in the `include:` section (create this section if it doesn't exist):

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
```

This enables SAST, but we should configure it to ignore unnecessary files. Add the following variables section (or add to your existing variables):

```yaml
variables:
  SAST_EXCLUDED_PATHS: "node_modules, public, .cache"
```

These two changes allow SAST to analyze our Gatsby code while ignoring directories that don't need scanning.

## Adding Secret Detection to the Pipeline

Next, let's add Secret Detection to identify any accidentally committed credentials.

1. Add another template to your `include:` section:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml
```

2. Let's configure Secret Detection to ignore unnecessary files:

```yaml
secret_detection:
  variables:
    SECRET_DETECTION_EXCLUDED_PATHS: "public, .cache"
```

This tells Secret Detection to skip over build artifacts and cached files.

## Adding Dependency Scanning to the Pipeline

Now, let's add Dependency Scanning to check our npm packages for vulnerabilities.

1. Add the Dependency Scanning template to your `include:` section:

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
```

## Complete Security Configuration

Here's how your complete `.gitlab-ci.yml` file should look with all security scanners enabled and configured:

```yaml
# Include security scanning templates
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml

image: node:18

stages:
  - setup
  - build
  - test
  - deploy_staging
  - deploy_production

variables:
  # Existing variables (from previous lessons)
  STAGING_DOMAIN: "${CI_PROJECT_NAME}-staging.surge.sh"
  PRODUCTION_DOMAIN: "${CI_PROJECT_NAME}.surge.sh"
  
  # Security scanner configurations
  SAST_EXCLUDED_PATHS: "node_modules, public, .cache"
  SECRET_DETECTION_EXCLUDED_PATHS: "public, .cache"


# Rest of your pipeline configuration...
# (install_dependencies, build_website, etc.)
```

## Viewing Security Results

After pushing these changes, run your pipeline and follow these steps to view the security results:

1. Go to your project in GitLab
2. Navigate to the pipeline that was triggered
3. Click on the **Security** tab
4. You'll see a list of all detected vulnerabilities, grouped by scanner

If your project has security vulnerabilities, they'll appear here. For example:

- SAST might find hardcoded credentials in your source code
- Secret Detection might find API keys committed to your repository
- Dependency Scanning might find vulnerable npm packages


## Security Best Practices for Gatsby Projects

1. **Keep dependencies updated**: Run `npm update` regularly
2. **Use environment variables**: Never hardcode secrets or credentials
3. **Sanitize user inputs**: Use libraries like DOMPurify for user-generated content
4. **Implement Content Security Policy**: Add CSP headers to prevent XSS attacks
5. **Review scanner results**: Check the Security tab after each pipeline run

## GitLab Community Edition vs. Premium/Ultimate

While basic security scanning is available in GitLab Community Edition, advanced features require Premium or Ultimate:

| Feature | Community Edition | Premium/Ultimate |
|---------|------------------|------------------|
| Basic SAST scanning | ✅ | ✅ |
| Secret Detection | ✅ | ✅ |
| Dependency Scanning | ✅ | ✅ |
| Container Scanning | ✅ | ✅ |
| License Compliance | ❌ | ✅ |
| Security Dashboard | ❌ | ✅ |
| Security Approvals | ❌ | ✅ |
| Vulnerability Management | ❌ | ✅ |

The scanners we've implemented in this lesson work in all GitLab editions, but the reporting and management features vary.

## Conclusion

By adding security scanning to your GitLab CI/CD pipeline, you've taken a crucial step toward building more secure applications. Security scanning helps you:

- Identify vulnerabilities early in the development cycle
- Prevent security issues from reaching production
- Maintain an audit trail of security findings
- Build security awareness among developers

In your DevOps journey, remember that security isn't a one-time task but an ongoing process. Regular scanning, code reviews, and dependency updates are essential to maintaining a secure application.

## [<<Previous](./2-environments.md) &nbsp;&nbsp; [>>Next](../day-4/1-kubernetes-integration.md) 