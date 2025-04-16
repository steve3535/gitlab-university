# Part 7: Deploying to Surge

Now that we have our site building successfully, let's set up deployment using Surge - a serverless deployment platform ideal for static websites.

## What is Surge?

Surge is a cloud platform that offers serverless deployment, meaning:
- You don't manage any servers
- Simple deployment process 
- Perfect for static sites like our Gatsby project
- Free tier available

## Local Surge Setup

First, let's test deployment locally:

1. Install Surge globally:
   ```bash
   npm install --global surge
   ```

2. Create a Surge account:
   ```bash 
   surge
   ```
   - Enter your email
   - Create a password
   - This same command is used for logging in later

3. Deploy manually first:
   ```bash
   cd public    # Navigate to your built files
   surge        # Deploy the site
   ```
   - Accept the default project path
   - Accept the generated domain or customize it
   - **Note the deployment URL provided**
   - Confirm the site is live!

In case you need to update the site later, you can deploy to the same domain:
```bash
surge --domain your-domain.surge.sh /workspaces/static-website/public
```

## Setting up Surge Credentials in GitLab

To automate deployments, we need to securely store Surge credentials in GitLab:

1. Generate a Surge token:
   ```bash
   surge token
   ```
   - Save the token shown

2. Add Surge credentials to GitLab:
   1. Go to Settings > CI/CD in your GitLab project
   2. Expand the "Variables" section
   3. Add two variables:
   
      **First Variable:**
      - Key: `SURGE_LOGIN`
      - Value: Your Surge email
      - Uncheck "Protect variable" to allow deployment from all branches
      - Leave "Mask variable" unchecked
      
      **Second Variable:**
      - Key: `SURGE_TOKEN`
      - Value: Your Surge token
      - Uncheck "Protect variable"
      - Check "Mask variable" to hide the token in logs

💡 **Security Tips:**
- Never commit credentials to your repository
- Use CI/CD variables for all secrets
- Mask sensitive values to prevent exposure in logs
- Consider enabling "Protect variable" for production credentials if you only deploy from protected branches

# Part 8: Setting Up Automated Deployment

Now let's update our pipeline to automatically deploy our site to Surge. Here's how we'll enhance our `.gitlab-ci.yml` configuration:

```yaml
# Default image for all jobs unless overridden
image: node:18

stages:
  - setup
  - build
  - test
  - deploy    # Add new deploy stage

install_dependencies:
  stage: setup
  tags:
    - docker
  script:
    - npm install
  artifacts:
    paths:
      - node_modules/.bin/
      - node_modules/gatsby/
    expire_in: 1 hour

build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies

test_artifact:
  stage: test
  tags:
    - docker
  image: alpine    # Override default image
  script:
    - grep -q "Gatsby" public/index.html
  needs:
    - build_website

test_website:
  stage: test
  tags:
    - docker
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby serve &
    - sleep 10
    - curl --retry 5 --retry-delay 2 http://localhost:9000 | grep -q "Gatsby"
  needs:
    - install_dependencies
    - build_website

security_scan:
  stage: test
  tags:
    - docker
  script:
    - npm audit --omit=dev --json > vulnerabilities-report.json || true
  artifacts:
    paths:
      - vulnerabilities-report.json
    expire_in: 1 week
    when: always
  needs:
    - install_dependencies
  allow_failure: true

deploy_to_surge:
  stage: deploy
  tags:
    - docker
  script:
    - npm install --global surge
    - surge --project ./public --domain your-chosen-name.surge.sh
  needs:
    - build_website
    - test_artifact
    - test_website
  environment:
    name: staging
    url: https://your-chosen-name.surge.sh
```

## Key Improvements

1. **Added Deploy Stage**:
   - New pipeline flow: Setup → Build → Test → Deploy
   - Deploy only executes if all required tests pass
   - Security scan allowed to fail without blocking deployment

2. **Deploy Job Configuration**:
   - Simple installation of Surge CLI
   - Direct deployment using artifacts from build stage
   - Uses environment variables for authentication
   - References built files from ./public directory
   - Defines an environment for tracking deployments

3. **Dependencies Management**:
   - Deploy job explicitly depends on successful build and tests
   - No need to rebuild or retest before deploying

## Deployment Configuration

1. Choose your unique Surge domain:
   ```yaml
   deploy_to_surge:
     script:
       - npm install --global surge
       - surge --project ./public --domain your-chosen-name.surge.sh
   ```
   Replace `your-chosen-name` with something unique

2. The deployment command explained:
   - `--project ./public`: Points to your built files
   - `--domain`: Your chosen Surge subdomain
   - Authentication happens automatically via CI/CD variables

💡 **Tips:**
- Test your domain name's availability before using it
- Keep domain name simple and memorable
- No need to specify SURGE_LOGIN and SURGE_TOKEN in the script
- They're automatically used from CI/CD variables

✨ **Success Indicators:**
- All stages complete successfully
- Deploy logs show: "Success published to yourdomain.surge.sh"
- Site is accessible at your Surge domain

## Assignment:

### Task 1: Personalize the website
Make the website your own by making at least one visible change:

- Add your name to the site title or homepage content
- Change a color in the site theme

Notes:  
* the main stylesheet is *src/components/layout.css*  
* the main homepage is *src/pages/index.js*  
* the site metadata is *gatsby-config.js*  
* to test changes locally: `npm run develop`
* Upon successful local changes, make sure it is automated through your CI/CD pipeline

### Task 2: Add Deployment Tests

For the next step, enhance your pipeline by adding a fourth stage called "deployment_tests" with a job that verifies the deployed website is working correctly:

The job will:
1. Run after successful deployment
2. Use a lightweight Alpine image with curl
3. Make an HTTP request to your deployed site
4. Verify the site contains expected content
5. Fail the pipeline if the deployment isn't working properly

Notes:
* to install curl in alpine, use: `apk add --no-cache curl`

By adding this stage, you create a full end-to-end verification of your deployment process, ensuring your website is not just deployed but also functioning correctly.

## [<<Previous](./7-static-website-2.md) &nbsp;&nbsp; [>>Next](../day-3/0-gitlab-predefined-variables.md)
