# Adding Multiple Environments to GitLab CI/CD Pipeline

Currently, our pipeline deploys directly to production, which isn't ideal for a continuous delivery process because:
- We can't test the deployment process beforehand
- We can't review changes in a pre-production environment
- We lack proper staging-to-production workflow

Let's enhance our pipeline by adding a staging environment.

## Reorganizing Pipeline Stages

First, let's clarify our stage names to reflect their actual purposes:

```yaml
stages:
  - build
  - test
  - deploy_staging
  - deploy_production
```

## Adding Staging Environment

Here's how to add a staging deployment:

```yaml
deploy_staging:
  stage: deploy_staging
  script:
    - npm i -g surge
    - surge --domain instazone-staging.surge.sh ./public
  environment:
    name: staging
    url: https://instazone-staging.surge.sh
```

## Updating Production Deployment

Update the production deployment to use environments:

```yaml
deploy_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain instazone.surge.sh ./public
  environment:
    name: production
    url: https://instazone.surge.sh
```

## The Complete Pipeline

```yaml
stages:
  - build
  - test
  - deploy_staging
  - deploy_production

# Your existing build and test jobs here...

deploy_staging:
  stage: deploy_staging
  script:
    - npm i -g surge
    - surge --domain instazone-staging.surge.sh ./public
  environment:
    name: staging
    url: https://instazone-staging.surge.sh

deploy_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain instazone.surge.sh ./public
  environment:
    name: production
    url: https://instazone.surge.sh
```

## Benefits of Having a Staging Environment

1. **Pre-Production Testing**
   - Test deployment process before production
   - Run integration tests
   - Verify system interactions
   - Test with production-like conditions

2. **Integration Testing**
   - Test interactions with external APIs
   - Verify system integrations
   - Run acceptance tests
   - Test complete system functionality

## Viewing Environments in GitLab

To view and manage your environments:

1. Go to **Operations > Environments** in the left sidebar
2. You'll see both environments listed (staging and production)
3. For each environment, you can:
   - See the latest deployed commit
   - Access the live environment URL
   - Track deployment history

## Understanding GitLab Environments

The `environment` keyword in your jobs helps GitLab:
- Track deployments
- Monitor deployment status
- Keep deployment history
- Provide easy access to deployed versions
- Associate jobs with specific environments

The two key properties for environments are:
```yaml
environment:
  name: staging       # Name of the environment
  url: https://...    # URL where it's deployed
```

# Using Variables in GitLab CI to Avoid Duplication

When working with GitLab CI pipelines, you'll often find yourself repeating values across different jobs - like domain names for different environments. Let's learn how to use variables to avoid this duplication and make our pipeline more maintainable.

## The Problem

Currently, our domain names are hardcoded in multiple places:
- In deployment jobs
- In environment URLs
- In test jobs

For example:
```yaml
deploy_staging:
  script:
    - surge --domain instazone-staging.surge.sh ./public
  environment:
    url: https://instazone-staging.surge.sh
```

## Solution: Using Variables

### Method 1: Define Variables in Pipeline
```yaml
variables:
  STAGING_DOMAIN: "instazone-staging.surge.sh"
  PRODUCTION_DOMAIN: "instazone.surge.sh"

deploy_staging:
  script:
    - surge --domain $STAGING_DOMAIN ./public
  environment:
    url: https://$STAGING_DOMAIN

deploy_production:
  script:
    - surge --domain $PRODUCTION_DOMAIN ./public
  environment:
    url: https://$PRODUCTION_DOMAIN
```

### Method 2: Define Variables in GitLab UI
You can also store variables in GitLab's UI:
1. Go to **Settings > CI/CD**
2. Expand **Variables**
3. Click **Add variable**
4. Add your domain variables:
   - Key: `STAGING_DOMAIN`
   - Value: `instazone-staging.surge.sh`
   - (Repeat for production domain)

## When to Use Variables?

Consider using variables when you:
1. Repeat values multiple times in your pipeline
2. Have values that might change
3. Want to separate configuration from pipeline code
4. Need to share values across different jobs

## Variable Scopes

You can define variables at different levels:
1. **Global Level** (in `variables` section):
   ```yaml
   variables:
     DOMAIN: "example.com"
   ```

2. **Job Level** (only for specific job):
   ```yaml
   deploy_job:
     variables:
       DOMAIN: "example.com"
   ```

## Testing Variable Changes

Our pipeline tests help ensure variable changes don't break anything:
- Production tests verify the domains are correct
- Failed tests indicate misconfigured variables
- Pipeline status shows if the changes worked

## Complete Example

```yaml
variables:
  STAGING_DOMAIN: "instazone-staging.surge.sh"
  PRODUCTION_DOMAIN: "instazone.surge.sh"

stages:
  - build
  - test
  - deploy_staging
  - deploy_production

deploy_staging:
  stage: deploy_staging
  script:
    - npm i -g surge
    - surge --domain $STAGING_DOMAIN ./public
  environment:
    name: staging
    url: https://$STAGING_DOMAIN

test_staging:
  stage: deploy_staging
  script:
    - curl https://$STAGING_DOMAIN | grep "Expected Content"

deploy_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain $PRODUCTION_DOMAIN ./public
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN

test_production:
  stage: deploy_production
  script:
    - curl https://$PRODUCTION_DOMAIN | grep "Expected Content"
```

Remember: If you find yourself repeating values in your pipeline configuration, it's a good indicator that those values should be moved to variables.
