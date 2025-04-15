# Using GitLab CI Predefined Variables and GitLab Pages

## Introduction

When deploying websites, tracking which version is currently live can be challenging. This lesson will show you how to use GitLab's predefined variables to add version information to your website and deploy it using GitLab Pages.

## What You'll Learn

- How to use GitLab's predefined CI variables
- How to inject version information into your website during build
- How to view your site using job artifacts
- How to verify the correct version is deployed

## Setup: Creating a Basic Website

Before setting up our CI pipeline, let's create and preview our basic website:

1. **Create a new project in GitLab**
   - Go to your GitLab instance (gitlab.thelinuxlabs.com)
   - Click "New project" → "Create blank project"
   - Name it "version-demo"
   - Make it public or internal so your classmates can see it

2. **Clone your new repository**
   ```bash
   git clone http://gitlab.thelinuxlabs.com/<your-username>/version-demo.git
   cd version-demo
   ```

3. **Create a simple HTML file**

   Create a file named `index.html` with the following content:

   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>GitLab CI Version Demo</title>
       <style>
           body {
               font-family: Arial, sans-serif;
               margin: 40px;
               line-height: 1.6;
           }
           .version-info {
               position: fixed;
               bottom: 10px;
               right: 10px;
               background-color: #f8f9fa;
               padding: 5px 10px;
               border-radius: 4px;
               font-size: 12px;
               color: #6c757d;
           }
       </style>
   </head>
   <body>
       <h1>Hello GitLab CI!</h1>
       <p>This page demonstrates how to inject version information into a deployed website.</p>
       
       <div class="version-info">
           Version: __VERSION_MARKER__
           <br>
           Built on: __DATE_MARKER__
       </div>
   </body>
   </html>
   ```

4. **Preview locally**
   
   You can view your HTML file locally before pushing:
   - Open the file in your web browser:
     ```bash
     # On Linux
     xdg-open index.html
     
     # On macOS
     open index.html
     
     # On Windows
     start index.html
     ```
   - You should see your basic page with placeholders for the version info

5. **Commit and push to GitLab**
   ```bash
   git add index.html
   git commit -m "Add basic HTML template with version placeholders"
   git push
   ```

## Why This Matters

Without version information visible on your site, you can't easily tell:
- Which commit is currently deployed
- When the last deployment occurred
- If your latest changes are actually live

Deploying with GitLab Pages provides a free and integrated way to host your site.

## Creating the CI Pipeline

Now that we have our basic website with version placeholders, let's create a CI pipeline that will:
1. Replace the placeholders with actual version information
2. Make the processed site available as a job artifact

Create a file named `.gitlab-ci.yml` in the root of your repository:

```yaml
image: alpine:latest

build_website:
  stage: build
  script:
    # Display the variables for debugging
    - echo "Building website with version ${CI_COMMIT_SHORT_SHA}"
    - echo "Commit date: ${CI_COMMIT_TIMESTAMP}"
    
    # Create directory for our built site
    - mkdir -p public
    
    # Copy our index.html to the public directory
    - cp index.html public/
    
    # Replace the markers with actual values using sed
    - sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
    - sed -i "s/__DATE_MARKER__/$(date)/" public/index.html
    
    # Show the result for debugging
    - echo "Content of public/index.html with version info:"
    - cat public/index.html | grep -A 2 Version
    - echo "Website build complete!"
  
  # Define the artifacts to make available
  artifacts:
    paths:
      - public/
    expire_in: 1 week

verify_build:
  stage: test
  needs: [build_website]
  script:
    - echo "Verifying build for version ${CI_COMMIT_SHORT_SHA}..."
    # Check that the built HTML contains our commit SHA
    - grep -q "${CI_COMMIT_SHORT_SHA}" public/index.html
    - echo "✅ Version verification successful!"
```

Commit and push this file:

```bash
git add .gitlab-ci.yml
git commit -m "Add CI pipeline with version injection"
git push
```

## How It Works

1. **Build Stage**:
   - Copies the index.html to a public directory
   - Uses `sed` to replace the markers with actual values
   - Stores the built site as a job artifact

2. **Test Stage**:
   - Verifies that the build contains the correct version information
   - This ensures our version injection worked correctly

## Viewing Your Site with Version Information

After the pipeline completes successfully, you can view your site with the injected version information:

1. Go to your project in GitLab
2. Navigate to **Build > Jobs**
3. Find the most recent successful job
4. Click the "Browse" button in the right sidebar under "Job Artifacts"
5. Navigate to the `public` directory
6. Click on `index.html` to view your site

You should now see your website with the actual commit SHA and build date replacing the placeholder markers!

## The Value of Job Artifacts

Job artifacts are powerful because:
1. They preserve the built output from your CI pipeline
2. They're accessible directly through the GitLab UI
3. They can be downloaded as a zip file
4. They provide a way to inspect and verify builds
5. They're available even for private projects

## Enhancing the Version Display

You can include more information in your version display:

```html
<div class="version-info">
    Version: __VERSION_MARKER__
    <br>
    Branch: __BRANCH_MARKER__
    <br>
    Built: __TIMESTAMP_MARKER__
    <br>
    Author: __AUTHOR_MARKER__
</div>
```

Then update your `.gitlab-ci.yml` to replace all markers:

```yaml
# Replace all markers with their respective values
- sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
- sed -i "s/__BRANCH_MARKER__/${CI_COMMIT_BRANCH}/" public/index.html
- sed -i "s/__TIMESTAMP_MARKER__/${CI_COMMIT_TIMESTAMP}/" public/index.html
- sed -i "s/__AUTHOR_MARKER__/${CI_COMMIT_AUTHOR}/" public/index.html
```

## Optional: GitLab Pages Integration

If your GitLab instance has Pages enabled, you can deploy your site by renaming the job to `pages`:

```yaml
pages:
  stage: deploy
  script:
    # Same script content as build_website
    ...
  artifacts:
    paths:
      - public/
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

With this configuration, your site would be available at a URL determined by your GitLab administrator (typically something like `http://<username>.pages.thelinuxlabs.com/version-demo/`).

## Troubleshooting Common Issues

1. **Version not showing**:
   - Ensure your marker is unique in the HTML
   - Check that the `sed` command runs after the HTML is available
   - Verify proper quoting in the `sed` command

2. **Wrong version showing**:
   - Make sure artifacts are properly configured
   - Confirm you're viewing the latest job artifacts

3. **Special characters in variables**:
   - Some GitLab variables may contain characters that need escaping
   - Use `echo` to debug the exact content of variables

## Integration with Other Projects

These techniques can be applied to any web project:

1. For static site generators:
   ```yaml
   build_website:
     script:
       - npm install     # or any other build system
       - npm run build
       - sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
   ```

2. For dynamic sites, consider:
   - Creating a version.txt file during build
   - Adding the version info to a footer or about page
   - Including it in API responses

## Assignment: Enhanced Version Display

1. Create a simple HTML page with placeholders for:
   - Commit SHA (short version)
   - Branch name
   - Build timestamp
   - Commit message

2. Write a `.gitlab-ci.yml` file that:
   - Builds the HTML file
   - Replaces all placeholders with GitLab variables
   - Makes the site available as a job artifact
   - Verifies the version information is correctly displayed

3. **Extra Challenge**: Add a clickable link to the commit page from your version info by using `${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}`

## Conclusion

Using GitLab's predefined variables is a powerful way to add dynamic information to your builds:

- It helps identify which version is deployed
- Makes debugging issues easier
- Provides transparency about when and by whom changes were made
- Establishes traceability between your code and builds

This technique is simple yet effective and can be applied to any type of web project.

## [<<Previous](../day-2/8-static-website-deploy.md) &nbsp;&nbsp; [>>Next](./1-schedule.md)