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

## Step 2: Better Version Display for Gatsby

Since we're working with Gatsby, we need to use a more React-friendly approach to ensure our version information persists after the page loads. The approach we'll use is:

1. Add environment variables during the build process
2. Use Gatsby's build system to access these variables
3. Create a dedicated component for version display

### Step 2.1: Create a Version Component

Create a new file at `src/components/VersionInfo.js`:

```jsx
import React from "react"

const VersionInfo = () => {
  // 👇 KEY POINT: We use environment variables instead of text markers
  // These will be set by our CI pipeline and included in the JavaScript bundle
  const version = process.env.GATSBY_VERSION || "development"
  const buildDate = process.env.GATSBY_BUILD_DATE || new Date().toISOString()
  const branch = process.env.GATSBY_BRANCH || "local"
  const commitUrl = process.env.GATSBY_COMMIT_URL || "#"
  
  return (
    <div className="version-info" style={{
      fontSize: '0.8rem',
      color: '#777',
      marginTop: '0.5rem'
    }}>
      {/* The values come directly from React, not injected later */}
      Version: {version}
      <br />
      Built on: {buildDate}
      <br />
      Branch: {branch}
      {commitUrl && (
        <>
          <br />
          <a 
            href={commitUrl}
            target="_blank"
            rel="noopener noreferrer"
            style={{ color: '#6b6b6b' }}
          >
            View commit
          </a>
        </>
      )}
    </div>
  )
}

export default VersionInfo
```

### Step 2.2: Update the Layout Component

Now update your `layout.js` file to use this component:

```jsx
import React from "react"
import PropTypes from "prop-types"
import { useStaticQuery, graphql } from "gatsby"
import Header from "./header"
import "./layout.css"
import VersionInfo from "./VersionInfo"

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
            marginTop: `var(--space-5)`,
            fontSize: `var(--font-sm)`,
          }}
        >
          © {new Date().getFullYear()} &middot; Built with
          {` `}
          <a href="https://www.gatsbyjs.com">Gatsby</a>
          <VersionInfo />
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

### Step 2.3: Commit the Changes

```bash
git add src/components/VersionInfo.js
git add src/components/layout.js
git commit -m "Add persistent version info component"
git push
```

## Step 3: Update the CI Pipeline

Now we need to update our CI pipeline to provide these environment variables to Gatsby during the build process:

```yaml
build_website:
  stage: build
  tags:
    - docker
  variables:
    NODE_OPTIONS: "--max-old-space-size=4096"
  script:
    - npm install gatsby-cli
    
    # 👇 IMPORTANT CHANGE: Set environment variables for Gatsby
    # The GATSBY_ prefix is required for client-side access
    - export GATSBY_VERSION=${CI_COMMIT_SHORT_SHA}
    - export GATSBY_BUILD_DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    - export GATSBY_BRANCH=${CI_COMMIT_BRANCH}
    - export GATSBY_COMMIT_URL=${CI_PROJECT_URL}/-/commit/${CI_COMMIT_SHA}
    
    # Run Gatsby build with these environment variables
    - ./node_modules/.bin/gatsby build
    
  artifacts:
    paths:
      - public/
  needs:
    - install_dependencies
```
## Troubleshooting Common Issues

1. **Version shows and then disappears**:
   - This happens when using HTML replacement techniques with React
   - Switch to the environment variable approach shown above
   - Make sure variables have the `GATSBY_` prefix for client-side access

2. **Environment variables not available in browser**:
   - Gatsby only exposes variables prefixed with `GATSBY_` to the browser
   - Verify your variable names start with `GATSBY_`
   - Restart the build after adding variables

3. **Variables not working in development**:
   - Add defaults for local development as shown in the component
   - Consider using `.env.development` for local testing

## [<<Previous](../day-2/8-static-website-deploy.md) &nbsp;&nbsp; [>>Next](./1-schedule.md)

