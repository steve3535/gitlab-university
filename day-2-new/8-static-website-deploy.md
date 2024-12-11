
### Part 7: Deploying to Surge

Now that we have our site building successfully, let's set up deployment using Surge - a serverless deployment platform ideal for static websites.

#### What is Surge?
Surge is a cloud platform that offers serverless deployment, meaning:
- You don't manage any servers
- Simple deployment process 
- Perfect for static sites like our Gatsby project
- Free tier available

#### Local Surge Setup
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
   surge       # Deploy the site
   ```
   - Accept the default project path
   - Accept the generated domain or customize it
   - **Note the deployment URL provided**
   - Confirm the site is live !

   ```
   # in case of a modification, run against the same URL with:
   surge --domain your-domain.surge.sh /workspaces/static-website/public
   ```   
#### Setting up Surge Credentials in GitLab

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

   First Variable:
   - Key: `SURGE_LOGIN`
   - Value: Your Surge email
   - Uncheck "Protect variable" to allow deployment from all branches
   - Leave "Mask variable" unchecked

   Second Variable:  
   - Key: `SURGE_TOKEN`
   - Value: Your Surge token
   - Uncheck "Protect variable"
   - Check "Mask variable" to hide the token in logs

💡 Security Tips:
- Never commit credentials to your repository
- Use CI/CD variables for all secrets
- Mask sensitive values to prevent exposure in logs
- Consider enabling "Protect variable" for production credentials if you only deploy from protected branches


### Part 8: Setting Up Automated Deployment

Now let's update our pipeline to automatically deploy our site to Surge. Here's the complete `.gitlab-ci.yml` configuration:

```yaml
# Default image for all jobs unless overridden
image: node:18

stages:
  - build
  - test
  - deploy    # Add new deploy stage

build_website:
  stage: build
  script:
    - npm install
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
  artifacts:
    paths:
      - ./public

test_artifact:
  stage: test
  image: alpine    # Override default image
  script:
    - grep -q "Gatsby" ./public/index.html

test_website:
  stage: test
  script:
    - npm install
    - npm install gatsby-cli
    - gatsby serve & 
    - sleep 3
    - curl localhost:9000 | tac | tac | grep -q "Gatsby"

deploy_to_surge:
  stage: deploy
  script:
    - npm install --global surge
    - surge --project ./public --domain yourdomain.surge.sh
```

#### Key Improvements

1. **Global Image Configuration**:
   - Moved `image: node` to top level
   - All jobs now use Node image by default
   - Only override when needed (like Alpine for test_artifact)

2. **Simplified Deploy Job**:
   - No need for Gatsby-related commands
   - Only installs Surge CLI
   - Uses environment variables for authentication
   - References built files from ./public directory

3. **Pipeline Stages**:
   ```
   Build → Test → Deploy
   ```
   - Tests run in parallel
   - Deploy only executes if all tests pass

#### Deployment Configuration

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

💡 Tips:
- Test your domain name's availability before using it
- Keep domain name simple and memorable
- No need to specify SURGE_LOGIN and SURGE_TOKEN in the script
- They're automatically used from CI/CD variables

✨ Success Indicators:
- All three stages complete successfully
- Deploy logs show: "Success published to yourdomain.surge.sh"
- Site is accessible at your Surge domain

3. **Next step: Assignment**:
   - We need a 4th stage "deployment tests" with a job that actually test the deployed website



