# Implementing Safe Deployment Workflows with GitLab Branches and Merge Requests

- Protect your master/main branch from direct pushes
- Configure your CI pipeline to handle different branch scenarios
- Work with merge requests effectively
- Set up proper deployment safeguards

## Why Branch-Based Workflows Matter

Working directly on the master branch can be risky. A single mistake (like removing an import statement or introducing a bug) can break the entire pipeline and prevent deployments. This goes against continuous deployment principles where we want to maintain a consistently deployable main branch.

By using feature branches and merge requests, we can:
- Isolate changes and test them independently
- Review code before it reaches the main branch
- Ensure the main branch stays deployable
- Enable better collaboration and code review

## Step 1: Adapting Your CI Pipeline for Branch Workflows

First, we need to modify your CI pipeline to handle different behavior for feature branches versus the main branch. Currently, your pipeline runs all stages for every branch, which isn't ideal. We want to:
- Run build and test stages for all branches
- Run deployment stages only for the main branch

Let's modify your .gitlab-ci.yml file. Add the following `only` directives to your deployment jobs:

```yaml

deploy_to_production:
  stage: deploy_production
  script:
    - npm i -g surge
    - surge --domain $PRODUCTION_DOMAIN ./public
  environment:
    name: production
    url: https://$PRODUCTION_DOMAIN
  when: manual
  allow_failure: false
  only:
    - master  # Add this line

test_deployed_site:
  stage: production-test
  image: alpine
  script:
    - apk add --no-cache curl
    - curl https://$PRODUCTION_DOMAIN | grep -q "$CI_COMMIT_SHORT_SHA"
  only:
    - master  # Add this line
```

## Step 2: Setting Up Branch Protection

To enforce our new workflow, we need to protect the master branch and set up proper access controls:

1. Go to your project's **Settings > Repository**
2. Expand the **Protected Branches** section
3. For the master branch, configure:
   - Set "Allowed to merge" to Maintainers and Developers
   - Set "Allowed to push" to No one
   - This ensures all changes must go through merge requests

## Step 3: Configuring Merge Request Settings

Let's set up some safeguards for merge requests:

1. Go to **Settings > General**
2. Expand the **Merge requests** section
3. Recommended settings:
   - Enable "Pipelines must succeed"
   - Enable "Delete source branch when merge request is accepted"
   - Consider enabling "Fast-forward merge" for a cleaner Git history


### Assignment:
- Push the new ci file tothe repository.
- What happens ? Why ?
- Resolve the issue


## Step 4: Working with Feature Branches

Let's walk through a typical workflow:

### Creating a Feature Branch

1. In GitLab, go to **Repository > Branches**
2. Click **New branch**
3. Name your branch following a convention, e.g., `feature/new-title`
4. Select master as the source branch
5. Click **Create branch**

### Making Changes

1. Clone the repository and switch to your feature branch
   ```
   # from your codespace
   git branch
   git branch -a
   git fetch --all
   git checkout -b feature/new-title origin/feature/new-title
   ``` 
2. Make your changes (e.g., updating website title)
3. Commit and push your changes
4. Notice that only build and test stages run in the pipeline

### Creating a Merge Request

1. After pushing your changes, create a merge request:
   - Add a descriptive title
   - Add a description explaining the changes
   - Check "Delete source branch when merge request is accepted"
2. Click **Submit merge request**

### Working with the Merge Request

1. Review the pipeline status in the merge request
2. You can click "Merge when pipeline succeeds" to automatically merge once all checks pass
3. GitLab will show deployment information:
   - Which environments will be affected
   - Option to stop deployments if needed
4. Once merged:
   - A new pipeline starts for the master branch
   - Changes are deployed according to your pipeline configuration
   - The source branch is automatically deleted

## Step 5: Verifying Deployments

After merging:
1. The master branch pipeline will run with all stages
2. Monitor deployments to staging and production
3. Use the "View App" links in the Environments page to verify your changes
4. Check the deployment status in the merge request interface

## Best Practices

1. **Branch Naming**: Use descriptive prefixes like:
   - `feature/` for new features
   - `bugfix/` for bug fixes
   - `hotfix/` for urgent fixes

2. **Merge Request Descriptions**:
   - Be clear about what changes were made
   - Explain why the changes were needed
   - Mention any related issues or dependencies

3. **Pipeline Reviews**:
   - Always check pipeline results before merging
   - Review deployment status and environment changes
   - Use the manual production deployment for extra safety

4. **Clean Up**:
   - Delete branches after merging
   - Keep the repository clean and organized
   - Use fast-forward merges when possible for a cleaner history

## Troubleshooting

- If a pipeline fails in your feature branch, fix the issues before merging
- If you need to make additional changes, simply push to the same branch
- The merge request will automatically update with new commits
- Use the "View App" links to verify changes in each environment

## Benefits of This Workflow

- Master branch remains stable and deployable
- Changes are properly tested before reaching production
- Team members can review changes before they're merged
- Deployment history is clearly tracked
- Easy rollback if needed through the GitLab interface

Remember: This workflow helps maintain code quality and deployment stability while enabling team collaboration. The extra steps might seem like overhead at first, but they help prevent production issues and make the development process more maintainable in the long run.



