### Part 5: Setting Up GitLab CI Pipeline

Now that we have our production build working locally, let's automate this process using GitLab CI.

1. Create the CI Pipeline Configuration
   Create a new file called `.gitlab-ci.yml` in your project root with the following content:
   ```yaml
   build_website:
     script:
       - npm install
       - npm install gatsby-cli
       - gatsby build
     artifacts:
       paths:
         - public
   ```
   Try pushing ...  

   🚨 Common Issue #1: npm command not found
   - If you get `npm: command not found`, it's because our default GitLab CI image (alpine) doesn't include Node.js
   - Fix: Add the following line at the start of your job:
     ```yaml
     image: node:18
     tags:
       - docker
     variables:
       NODE_OPTIONS: "--max-old-space-size=4096"  # Increase Node's memory limit
     ```
   Try pushing once again ...

   🚨 Another eventual Issue: gatsby command not found
   - Try fix the error
   - **Hint 1**: its a PATH issue
   - **Hint 2**: to find out use find command in your local dev environment :)
        

3. Test Our Build Artifact
   Let's add testing to ensure our build is correct:
   ```yaml
   images: node
   stages:
     - build
     - test

   build_website:
     stage: build
     ...
     #same as before
     ...

   test_artifact:
     stage: test
     image: alpine
     tags:
      - node
     script:
       - grep -q "Gatsby" ./public/index.html
   
   test_website:
     stage: test
     tags:
       - docker
     script:
       - npm install
       - npm install gatsby-cli
       - ./node_modules/.bin/gatsby serve &
       - sleep 5
       - curl --retry 5 --retry-dely 2 http://localhost:9000  | grep -q "Gatsby"
   ```

   💡 Key Concepts:
   - Jobs in the same stage (like both test jobs) run in parallel
   - Using `&` makes gatsby serve run in background
   - The `sleep 5` gives the server time to start
   - The `-q` flag makes grep quiet for cleaner logs

   ✨ Success Checks:
   - The build job should create a `public` directory with your site
   - Both test jobs should pass
   - You can browse artifacts in GitLab UI to inspect the built files

   🚨 Common Issues:
   1. Timeout Issues
      - Jobs have a 1-hour default timeout
      - Use the cancel button if a job hangs
      
   2. Parallel Pipelines
      - New commits trigger new pipelines
      - Previous pipelines continue running
      - Cancel old pipelines manually if needed

   💡 Pipeline Optimization Tips:
   - Using `alpine` image for simple test jobs makes them faster
   - Parallel test jobs can speed up pipeline execution
   - Jobs with dependencies must be in different stages
   - Cancel unnecessary running pipelines to save resources

### Viewing Pipeline Results

1. Navigate to CI/CD > Pipelines in your GitLab project
2. Click on the latest pipeline to see all jobs
3. Click on any job to see detailed logs
4. For the build job:
   - Find the "Artifacts" section on the right
   - Click "Browse" to see the built website files
   - Download artifacts to inspect locally if needed

## [<<Previous](./5-static-website-1.md) &nbsp;&nbsp; [>>Next](./8-static-website-deploy.md)
