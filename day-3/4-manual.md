# Adding Manual Approvals to GitLab CI/CD Pipeline

While automated deployments are great for staging environments, production deployments often require manual review and approval. Let's learn how to configure specific jobs to run only after manual approval.

## The Problem

Currently, our pipeline automatically deploys to production after staging succeeds. This means:
- No manual review of staging changes
- No control over production deployment timing
- No opportunity to verify staging before production

## Adding Manual Triggers

### Basic Manual Job Configuration
```yaml
deploy_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain $PRODUCTION_DOMAIN ./public
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN
  when: manual  # This makes the job manual
```

## Understanding Pipeline Behavior

By default, when adding `when: manual`:
- The job waits for manual trigger
- Subsequent stages still run automatically
- Pipeline may show partial success/failure

### Blocking Subsequent Stages

To make subsequent stages wait for the manual job:
```yaml
deploy_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain $PRODUCTION_DOMAIN ./public
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN
  when: manual
  allow_failure: false  # This blocks subsequent stages until manual job runs
```

## How to Use Manual Deployments

1. Wait for staging deployment to complete
2. Review changes in staging environment
3. If satisfied, go to pipeline view
4. Click the manual deploy_production job (play button)
5. Pipeline continues with production deployment and tests

## Benefits

- Control over production deployment timing
- Opportunity to review staging
- Prevention of accidental deployments
- Manual verification step
- Maintained deployment history

## Environment View

In **Operations > Environments**, you can now see:
- Different versions between staging and production
- Clear indication of manual deployment needs
- History of manual deployments
- Deployment status tracking

## Best Practices

1. Always review staging before triggering production
2. Use meaningful commit messages for easy review
3. Consider adding approval requirements
4. Document deployment procedures
5. Verify production tests after manual deployment

Remember: Manual deployments are a key part of a controlled and safe deployment process, especially for production environments.
