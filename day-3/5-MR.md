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
5. Back to your codespace, checkout main and observe the source graph
6. Can you confirm the feature branch has been deleted as well ?
   
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

## Assignement 

In this assignment, you'll practice the merge request workflow we just learned by implementing three small changes to your existing Gatsby website. 
You'll create separate branches and merge requests for each change, simulating a real-world development workflow.

## Prerequisites
- Your existing Gatsby website with CI/CD pipeline
- GitLab repository with protected master branch
- Configured merge request settings as per the tutorial

## Tasks

### Task 1: Add Build Information Footer
Create a merge request that adds a footer to your website displaying build information:

1. Create a branch named `feature/build-info-footer`
2. Add a footer component that displays:
   - Build version (using `$CI_COMMIT_SHORT_SHA`)
   - Build timestamp (using `$CI_COMMIT_TIMESTAMP`)
3. Style it appropriately (maybe a subtle gray background)
4. Create a merge request with a clear description

### Task 2: Fix CSS Primary color
Create a merge request that changes the rimary color of the website:

1. Create a branch named `fix/change-color`
2. Use file *layout.css* under *src/components*:
3. Create a merge request explaining the improvements

### Task 3: Add Social Links
Create a merge request that adds social media links:

1. Create a branch named `feature/social-links`
2. Add links to (hypothetical) social media profiles:
   - GitHub
   - LinkedIn
   - Twitter
3. Use appropriate icons
4. Create a merge request with screenshots

## Requirements

For each merge request:
1. Follow the branch naming convention as shown
2. Write clear commit messages
3. Add a descriptive merge request description
4. Enable the "Delete source branch when merge request is accepted" option
5. Test your changes in the review environment before requesting review

## Solution Guide

### Task 1
In src/components, create a new file *footer.js*: 
```javascript
import React from 'react'

const Footer = () => {
  return (
    <footer style={{
      backgroundColor: '#f5f5f5',
      padding: '1rem',
      textAlign: 'center',
      position: 'fixed',
      bottom: 0,
      width: '100%',
      fontSize: '0.8rem',
      color: '#666'
    }}>
      <p>Version: __VERSION_MARKER__ </p>
      <p>Built at: __TIMESTAMP_MARKER__</p>
      <p>By: __AUTHOR_MARKER__</p>
    </footer>
  )
}

export default Footer
``` 
In the main index.js, integrate footer.js:
```javascript
import Footer from '../components/footer'

// Inside your main component, before the closing tag:
return (
  <div>
    {/* existing content */}
    <Footer />
  </div>
)
```

### Task 3

```javascript
import React from 'react'

const SocialLinks = () => {
  const socialStyles = {
    container: {
      display: 'flex',
      justifyContent: 'center',
      gap: '2rem',
      margin: '2rem 0'
    },
    link: {
      color: 'var(--color-primary)',
      textDecoration: 'none',
      fontSize: '1.2rem',
      transition: 'color 0.3s ease'
    }
  }

  return (
    <div style={socialStyles.container}>
      <a 
        href="https://github.com/yourusername" 
        style={socialStyles.link}
        target="_blank"
        rel="noopener noreferrer"
      >
        GitHub
      </a>
      <a 
        href="https://linkedin.com/in/yourusername" 
        style={socialStyles.link}
        target="_blank"
        rel="noopener noreferrer"
      >
        LinkedIn
      </a>
      <a 
        href="https://twitter.com/yourusername" 
        style={socialStyles.link}
        target="_blank"
        rel="noopener noreferrer"
      >
        Twitter
      </a>
    </div>
  )
}

export default SocialLinks
```
Integrate it to the main page:  

```javascript
import SocialLinks from '../components/social-links'

// Add before the Footer component:
<SocialLinks />
<Footer />
``` 
## Success Criteria

Your assignment is successful when:
- All three merge requests are created correctly
- Each change works in its review environment
- Changes don't break existing functionality
- Merge requests follow the required format
- Pipeline passes for all changes
- Changes are successfully merged to master

Remember: The goal is to practice the merge request workflow while making meaningful improvements to your site. Focus on the process as much as the actual changes.

## Submission
Your final master branch should have all changes deployed to production.
