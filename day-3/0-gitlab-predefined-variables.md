# Using GitLab CI Predefined Variables

## Introduction

When deploying websites through a CI pipeline, tracking which version is currently live can be challenging. This lesson will show you how to use GitLab's predefined variables to add version information to your deployments.

## What You'll Learn

- How to use GitLab's predefined CI variables
- How to inject version information into your website during build
- How to verify the correct version is deployed

## Why This Matters

Without version information visible on your site, you can't easily tell:
- Which commit is currently deployed
- When the last deployment occurred
- If your latest changes are actually live

## A Simpler Approach

For this lesson, we'll use a simplified pipeline focusing specifically on the version injection technique. This will make the concepts clearer without the complexity of our previous multi-stage pipeline.

## Step 1: Understanding GitLab Predefined Variables

GitLab automatically provides many [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html) that contain useful information about your project, pipeline, and commit.

Some of the most useful variables for version tracking:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `CI_COMMIT_SHORT_SHA` | First 8 characters of commit SHA | `1a2b3c4d` |
| `CI_COMMIT_BRANCH` | The branch name | `main` |
| `CI_COMMIT_TIMESTAMP` | Commit timestamp | `2023-03-15T12:34:56+00:00` |
| `CI_COMMIT_AUTHOR` | Commit author | `Jane Doe` |

For our version marker, we'll primarily use `CI_COMMIT_SHORT_SHA` because it's:
- Concise enough to display
- Unique for each commit
- Automatically provided in every pipeline

## Step 2: Creating a Simple Website with Version Marker

Let's create a minimal HTML file with a placeholder for our version information:

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

Save this as `index.html` in your project root.

## Step 3: Creating a Simple Pipeline

Create a `.gitlab-ci.yml` file with a basic build and deploy pipeline:

```yaml
image: alpine:latest

stages:
  - build
  - deploy
  - verify

build_website:
  stage: build
  script:
    # Display the variables for debugging
    - echo "Building website with version ${CI_COMMIT_SHORT_SHA}"
    - echo "Commit date: ${CI_COMMIT_TIMESTAMP}"
    
    # Create a directory for our built site
    - mkdir -p public
    
    # Copy our index.html to the public directory
    - cp index.html public/
    
    # Replace the markers with actual values
    - sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
    - sed -i "s/__DATE_MARKER__/$(date)/" public/index.html
    
    # Show the result for debugging
    - cat public/index.html | grep Version
  artifacts:
    paths:
      - public/

deploy_website:
  stage: deploy
  script:
    - echo "Deploying website version ${CI_COMMIT_SHORT_SHA}"
    # Here you would add commands to deploy to your hosting service
    # For demonstration, we'll just simulate a successful deployment
    - echo "Website deployed successfully!"
  artifacts:
    paths:
      - public/

verify_deployment:
  stage: verify
  script:
    - echo "Verifying deployment of version ${CI_COMMIT_SHORT_SHA}"
    # Here we would normally curl the live site
    # For demonstration, we'll just check our built file
    - grep -q "${CI_COMMIT_SHORT_SHA}" public/index.html
    - echo "✅ Version verification successful!"
```

## How It Works

1. **Build Stage**:
   - Copies the index.html to a public directory
   - Uses `sed` to replace the markers with actual values
   - Stores the built site as an artifact

2. **Deploy Stage**:
   - Would normally upload the site to a hosting service
   - In this example, we're just simulating deployment

3. **Verify Stage**:
   - Checks that the built HTML contains our commit SHA
   - Ensures the version information was properly injected

## Important Note About `sed`

The `sed` command needs proper quoting to work correctly:

```bash
sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
```

Double quotes (`"`) are essential here because they allow the shell to expand the `${CI_COMMIT_SHORT_SHA}` variable. Single quotes would treat it as a literal string.

## Enhancing Your Version Display

You can add more information to your version display:

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

## Troubleshooting Common Issues

1. **Version not showing**:
   - Ensure your marker is unique in the HTML
   - Check that the `sed` command runs after the HTML is available
   - Verify proper quoting in the `sed` command

2. **Wrong version showing**:
   - Make sure artifacts are properly configured
   - Confirm the deployment is using the correct build artifacts

3. **Special characters in variables**:
   - Some GitLab variables may contain characters that need escaping
   - Use `echo` to debug the exact content of variables

## Integration with Your Gatsby Project

To apply this technique to your Gatsby project from previous lessons, you'd need to:

1. Add the version marker to your React components:
   ```jsx
   <footer>
     <div className="version-info">Version: __VERSION_MARKER__</div>
   </footer>
   ```

2. Add the `sed` command after the Gatsby build step:
   ```yaml
   build_website:
     script:
       - npm install
       - npm run build
       - sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/" public/index.html
   ```

## Assignment: Enhanced Version Display

1. Create a simple HTML page with placeholders for:
   - Commit SHA (short version)
   - Branch name
   - Build timestamp
   - Commit message

2. Write a `.gitlab-ci.yml` file that:
   - Builds the HTML file
   - Replaces all placeholders with GitLab variables
   - Deploys the site (you can simulate this)
   - Verifies the version information is correctly displayed

3. **Extra Challenge**: Make the version info only appear when clicking a "Version" button or hovering over a specific element

## Conclusion

Using GitLab's predefined variables is a powerful way to add dynamic information to your deployments. This technique:

- Helps identify which version is deployed
- Makes debugging issues easier
- Provides transparency about when and by whom changes were made
- Establishes traceability between your code and live site

In real-world projects, this small addition can save significant time when tracking down bugs or verifying successful deployments.

## [<<Previous](../day-2/8-static-website-deploy.md) &nbsp;&nbsp; [>>Next](./1-schedule.md)