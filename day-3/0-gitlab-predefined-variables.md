# Using GitLab CI Predefined Variables in Your Gatsby Project

## Introduction

After successfully building and deploying your Gatsby site to Surge in the previous lesson, you may be wondering: "How can I tell which version of my site is currently deployed?" This is a common challenge with continuous deployments.

Without version information visible on your site, you can't easily tell:
- Which commit generated the current deployment
- When the last deployment occurred
- If your latest changes are actually deployed

## Solution Overview

We'll enhance our Gatsby project by:
1. Using GitLab's predefined CI variables to get commit information
2. Injecting this information into the HTML during the build process
3. Displaying it on our site in a subtle but accessible way
4. Verifying the deployed version in our test stage

## Step 1: Understand Available Predefined Variables

GitLab provides many predefined variables we can use:   
[predefined variables documentation](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)    

For version tracking, these are particularly useful:

| Variable | Description | Example Value |
|----------|-------------|---------------|
| `CI_COMMIT_SHORT_SHA` | First 8 characters of commit SHA | `1a2b3c4d` |
| `CI_COMMIT_BRANCH` | The branch name | `main` |
| `CI_COMMIT_TIMESTAMP` | Commit timestamp | `2023-03-15T12:34:56+00:00` |
| `CI_COMMIT_AUTHOR` | Commit author | `Jane Doe` |
| `CI_COMMIT_MESSAGE` | The commit message | `Update homepage content` |

For our Gatsby site, we'll primarily use `CI_COMMIT_SHORT_SHA` because it's:
- Concise enough to display
- Unique for each commit
- Automatically provided in every pipeline

## Step 2: Add Version Display to Your Gatsby Site

First, let's modify our Gatsby site to include a place for the version information:

1. Edit the layout component (`src/components/layout.js`) to add a version display in the footer:

```jsx
import React from "react"
import PropTypes from "prop-types"
import { useStaticQuery, graphql } from "gatsby"

import Header from "./header"
import "./layout.css"

const Layout = ({ children }) => {
  const data = useStaticQuery(graphql`
    query SiteTitleQuery {
      site {
        siteMetadata {
          title
        }
      }
    }
  `)

  return (
    <>
      <Header siteTitle={data.site.siteMetadata?.title || `Title`} />
      <div
        style={{
          margin: `0 auto`,
          maxWidth: 960,
          padding: `0 1.0875rem 1.45rem`,
        }}
      >
        <main>{children}</main>
        <footer
          style={{
            marginTop: `2rem`,
          }}
        >
          © {new Date().getFullYear()}, Built with
          {` `}
          <a href="https://www.gatsbyjs.com">Gatsby</a>
          <div className="version-info" style={{
            fontSize: '0.8rem',
            color: '#999',
            marginTop: '0.5rem'
          }}>
            Version: __VERSION_MARKER__
            <br />
            Built on: __DATE_MARKER__
          </div>
        </footer>
      </div>
    </>
  )
}

Layout.propTypes = {
  children: PropTypes.node.isRequired,
}

export default Layout
```

2. Commit and push this change:
```bash
git add src/components/layout.js
git commit -m "Add version information display to footer"
git push
```

## Step 3: Update the CI Pipeline

Now, let's modify our CI pipeline to inject the version information during the build process.

Here's what happens in sequence:
1. Gatsby builds our site, converting React components to static HTML
2. The markers from our React components (`__VERSION_MARKER__`) are preserved in the output HTML
3. We then use `sed` to replace these markers in all generated HTML files

Edit your `.gitlab-ci.yml` file to update the `build_website` job:

```yaml
build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"
  script:
    - npm install gatsby-cli
    - ./node_modules/.bin/gatsby build
    # Add version information to the *generated* HTML files
    - echo "Injecting version information: ${CI_COMMIT_SHORT_SHA}"
    - find public -name "*.html" -exec sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/g" {} \;
    - find public -name "*.html" -exec sed -i "s/__DATE_MARKER__/$(date)/g" {} \;
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies
```

> **Why we find and replace in HTML files**: When Gatsby builds our site, it converts our React components to static HTML files in the `public` directory. We add markers to our React components, but need to replace those markers in the *generated* HTML after the build is complete.

## Step 4: Add Version Verification to Deployment Tests

Now, let's enhance our deployment test to verify that the correct version is deployed:

```yaml
deployment_test:
  stage: deployment_tests
  tags:
    - docker
  image: alpine
  script:
    - apk add --no-cache curl
    - echo "Verifying deployment of version ${CI_COMMIT_SHORT_SHA}"
    - curl --retry 5 --retry-delay 2 https://your-chosen-name.surge.sh | grep -q "${CI_COMMIT_SHORT_SHA}"
    - echo "✅ Version verification successful!"
  needs:
    - deploy_to_surge
```

This test job:
1. Installs `curl` in the Alpine container
2. Fetches your deployed site
3. Verifies it contains the expected commit SHA
4. Fails if the version information is missing or incorrect

## Enhanced Version Display

For a more professional approach, you can include more detailed information:

1. Update your layout.js file:
```jsx
<div className="version-info" style={{
  fontSize: '0.8rem',
  color: '#999',
  marginTop: '0.5rem'
}}>
  Version: __VERSION_MARKER__
  <br />
  Branch: __BRANCH_MARKER__
  <br />
  Built: __TIMESTAMP_MARKER__
  <br />
  Commit: <a href="__COMMIT_URL_MARKER__">View changes</a>
</div>
```

2. Update your build script:
```yaml
- find public -name "*.html" -exec sed -i "s/__VERSION_MARKER__/${CI_COMMIT_SHORT_SHA}/g" {} \;
- find public -name "*.html" -exec sed -i "s/__BRANCH_MARKER__/${CI_COMMIT_BRANCH}/g" {} \;
- find public -name "*.html" -exec sed -i "s/__TIMESTAMP_MARKER__/${CI_COMMIT_TIMESTAMP}/g" {} \;
- find public -name "*.html" -exec sed -i "s|__COMMIT_URL_MARKER__|${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}|g" {} \;
```

Note the use of `|` as separator in the last `sed` command, because the URL contains forward slashes.

## Troubleshooting Common Issues

1. **Version not showing**:
   - Check that your markers are unique enough in the HTML
   - Ensure the `sed` commands run after the Gatsby build
   - Verify that all HTML files are being processed

2. **Wrong version showing**:
   - Make sure artifacts are properly configured
   - Confirm the deployment is using the latest build artifacts

3. **Special characters in variables**:
   - Some GitLab variables may contain characters that need escaping
   - Use `echo` to debug the exact content of variables
   - Consider base64 encoding for complex values

## Assignment: Enhanced Deployment Information

Extend your Gatsby site with a complete deployment information panel:

1. Create a new component called `DeploymentInfo.js` that:
   - Displays version information in a collapsible panel
   - Shows the CI/CD pipeline URL
   - Includes a link to the specific commit

2. Update your CI/CD pipeline to:
   - Inject all required variables into the HTML
   - Add a test that verifies all information is present
   - Include the pipeline ID and job ID in the deployment info

3. **Bonus Challenge**: Make the version info toggle between minimal and detailed views on click

## Conclusion

By adding version information to your Gatsby site, you've:
1. Improved traceability between code and deployments
2. Made debugging deployment issues much easier
3. Added transparency to your deployment process
4. Created a better developer and operations experience

In the next lesson, we'll explore how to optimize your CI/CD pipeline with caching.

## [<<Previous](../day-2/8-static-website-deploy.md) &nbsp;&nbsp; [>>Next](./1-schedule.md)

