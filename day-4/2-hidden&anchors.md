# Optimizing GitLab CI/CD Pipeline: Job Disabling and YAML Anchors

## Part 1: Disabling Jobs Temporarily

When working on specific stages or jobs in your pipeline, you might want to skip certain jobs to save time and resources.  
GitLab provides a simple way to temporarily disable jobs without removing their configuration.

### Disabling Jobs with Dot Prefix
To disable a job, simply add a dot (`.`) at the beginning of the job name. Here's how:

```yaml
# This job will run
build_website:
  stage: build
  script:
    - echo "This will run"

# This job is disabled and will be skipped
.test_website:
  stage: test
  script:
    - echo "This will NOT run"
```

### Use Cases for Job Disabling
1. **Development Focus**: When working on specific stages
2. **Troubleshooting**: To isolate issues in specific pipeline parts
3. **Resource Management**: To reduce pipeline execution time
4. **Testing Changes**: To test modifications to specific stages

### Best Practices
- Keep disabled jobs in the configuration for reference
- Use meaningful job names even when disabled
- Document why a job is disabled (using comments)
- Re-enable jobs once work is completed

## Part 2: YAML Anchors - Reducing Duplication

### What are YAML Anchors?
YAML anchors are a powerful feature that helps reduce duplication in your pipeline configuration. They allow you to:
- Define reusable configurations
- Inherit properties from other objects
- Maintain DRY (Don't Repeat Yourself) principles

### Basic Anchor Syntax
```yaml
# Define an anchor
.default_config: &default
  image: alpine
  tags:
    - docker
  before_script:
    - echo "Preparing environment"

# Use the anchor
test_job:
  <<: *default  # Inherits all properties from default_config
  script:
    - echo "Running tests"
```
#### Assignement: test it

### Advanced Anchor Usage

#### 1. Multiple Inheritance
```yaml
.base: &base
  image: alpine
  tags:
    - docker

.test_template: &test
  <<: *base
  stage: test
  before_script:
    - echo "Test preparation"

unit_test:
  <<: *test
  script:
    - echo "Running unit tests"

integration_test:
  <<: *test
  script:
    - echo "Running integration tests"
```
#### Assignement: test it

#### 2. Partial Override
```yaml
.deploy_template: &deploy_config
  stage: deploy
  environment:
    url: https://$CI_ENVIRONMENT_SLUG.example.com
    on_stop: stop_review

deploy_review:
  <<: *deploy_config
  environment:
    name: review/$CI_COMMIT_REF_SLUG  # Overrides only the name
  script:
    - echo "Deploying to review"
```

### Real-World Example
Here's a practical example combining both concepts:

```yaml
# Base configurations
.base_config: &base_config
  image: alpine
  tags:
    - docker

.deploy_template: &deploy_template
  <<: *base_config
  variables:
    GIT_STRATEGY: none
  environment:
    on_stop: stop_environment

# Active jobs
deploy_review:
  <<: *deploy_template
  stage: review
  script:
    - echo "Deploying review environment"
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: https://review-${CI_COMMIT_REF_SLUG}.example.com

# Disabled jobs (for reference or temporary disabling)
.deploy_staging:
  <<: *deploy_template
  stage: deploy
  script:
    - echo "Deploying to staging"
  environment:
    name: staging
```

### Benefits of Using Anchors
1. **Maintainability**: Single source of truth for common configurations
2. **Readability**: Cleaner pipeline configurations
3. **Consistency**: Ensures similar jobs share common configurations
4. **Flexibility**: Easy to modify shared configurations

### Best Practices for Anchors
1. Use meaningful names for anchors
2. Keep anchor definitions at the top of the file
3. Comment complex anchor structures
4. Use anchors for commonly repeated configurations
5. Don't overuse - keep it simple when possible

### Common Use Cases
1. **Common Job Configurations**
   - Shared image definitions
   - Common script sequences
   - Default variable sets

2. **Environment Configurations**
   - Deployment templates
   - Environment-specific variables
   - Common environment settings

3. **Testing Templates**
   - Common test configurations
   - Shared test preparation steps
   - Test reporting templates

### Troubleshooting Tips
1. **Invalid Anchor References**
   - Ensure anchor names are unique
   - Verify anchor definitions are before usage
   - Check for typos in anchor names

2. **Unexpected Behavior**
   - Review inheritance chain
   - Check for overridden values
   - Verify anchor content

3. **Maintenance Issues**
   - Keep anchor definitions organized
   - Document complex anchor relationships
   - Regular review of anchor usage

