# Using GitLab CI Predefined Variables Tutorial

When deploying website changes through a CI pipeline, it can be difficult to identify which version is currently live. Without version information visible on the site, you can't easily tell:
- Which commit generated the current deployment
- When the last deployment occurred
- If your latest changes are actually deployed

## Solution Overview

We'll solve this by:
1. Using GitLab's predefined CI variables to get commit information
2. Injecting this information into the HTML during the build process
3. Verifying the deployed version in our test stage

## Step 1: Choose the Right Predefined Variable

GitLab provides many predefined variables we can use:   
[predefined variables documentation](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)    
For version tracking, we'll use `CI_COMMIT_SHORT_SHA`, which provides an 8-character commit hash. This is:  
- Short enough to display
- Unique enough to identify deployments
- Automatically provided by GitLab

## Step 2: Add a Version Marker

Add a placeholder in your index.js where the version will appear:

```html
<div>Version: __VERSION_MARKER__</div>
```

Note: The marker format `__VERSION_MARKER__` is arbitrary - you can use any unique string that won't appear elsewhere in your code.

## Step 3: Update the Build Job

Modify your CI pipeline's build job to replace the marker with the actual version. Add this command after your main build step:

```yaml
build:
  script:
    - echo $CI_COMMIT_SHORT_SHA  # Debug: verify the variable value
    - gatsby build  # Or your actual build command
    - sed -i "s/__VERSION_MARKER__/$CI_COMMIT_SHORT_SHA/" public/index.html

# Be aware of the "" with sed, otherwise the Gitlab variable will not be substituted
```

The `sed` command explained:
- `-i`: Edit the file in place
- `s/pattern/replacement/`: Substitute pattern with replacement
- File path: `public/index.html` is where our built file is located

## Step 4: Add Version Verification

Update your test job to verify the correct version is deployed:

```yaml
test:
  script:
    - curl https://your-site.example.com | grep "$CI_COMMIT_SHORT_SHA"
```

This ensures:
- The site is accessible
- The deployed version matches our build

## Common Issues and Solutions

1. **Version not showing**: Check that your marker is unique and the sed command is running after the build
2. **Wrong version showing**: Verify build artifacts are properly configured
3. **Test failing**: Ensure your grep pattern exactly matches the injected version format

## Next Steps: Assignment

Consider enhancing this setup by:
- Adding more deployment metadata (build time, branch name, commit_author)
```html
<div class="deployment-info">
  <p>Version: __VERSION_MARKER__</p>
  <p>Deployed from: __BRANCH_MARKER__</p>
  <p>Built at: __TIMESTAMP_MARKER__</p>
  <p>Author: __AUTHOR_MARKER__</p>
</div>
```

## Conclusion

Using GitLab CI predefined variables provides a simple way to add dynamic information to your deployments. This helps with:
- Deployment verification
- Issue debugging
- Release tracking

