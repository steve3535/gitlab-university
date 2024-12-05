# GitLab Project Management Setup Guide - Individual Project

## Overview

Before writing any code, we'll set up proper project management in GitLab. This foundation will help you organize your work and track progress effectively.  
Good project management ensures your project stays organized, scalable, and trackable—even for simple tasks.  
By the end of this section, you will have a well-organized GitLab project with clear labels, milestones, and issues that streamline your development process.  

## 1. Project Creation

1. Log into GitLab
2. Click "New Project"
3. Select "Create blank project"
4. Fill in project details:
   - Project name: `simple-webapp-[your-gitlab-username]`
   - "Visibility Level: Set to 'Private' to protect your code from being publicly accessible while you're learning."  
   - Initialize with a README: Yes
     A README file gives your project an initial structure and lets others understand its purpose.  

## 2. Label Setup

Labels help categorize and prioritize work. Create the following labels:

| Label Name    | Color  | Description |
|--------------|--------|-------------|
| feature      | #428BCA | New functionality |
| bug          | #FF0000 | Something isn't working |
| documentation| #4CAF50 | Documentation updates |
| testing      | #FFC107 | Testing related tasks |
| ci-cd        | #9C27B0 | CI/CD pipeline tasks |

To create labels:
1. Go to Manage → Labels
2. Click "New label"
3. Create each label with the specified colors
4. Add meaningful descriptions

## 3. Milestone Creation

Create a milestone to group related issues:

1. Go to Issues → Milestones
2. Click "New milestone"
3. Set up milestone details:
   - Title: "MVP Release"
   - Due date: End of today
   - Description: "Basic web application with CI/CD pipeline"

## 4. Issue Creation

Create these essential issues:

1. "Setup basic HTML/CSS structure"
   - Label: feature
   - Description: "Create basic webpage layout with header, content area, and footer"
   
2. "Configure CI/CD pipeline"
   - Label: ci-cd
   - Description: "Set up basic GitLab CI/CD pipeline with build and test stages"
   
3. "Implement basic Node.js API"
   - Label: feature
   - Description: "Create simple API endpoint returning JSON data"
   
4. "Add security scanning"
   - Label: ci-cd
   - Description: "Implement basic security scanning in CI pipeline"
   
5. "Create project documentation"
   - Label: documentation
   - Description: "Document project setup and deployment process"

For each issue:
1. Go to Plan → Issues → List
2. Click "New issue"
3. Add appropriate title and description
4. Assign to yourself
5. Add appropriate label
6. Link to MVP milestone

## 5. Project Board Setup

Create a Kanban board to visualize work:

1. Go to Project information → Project overview
2. Click "Add list"
3. Create four lists:
   - To Do
   - Doing
   - Review
   - Done

## 6. Time Tracking

Enable time tracking for your issues:

1. In each issue, you can:
   - Estimate time: `/estimate 2h`
   - Start work: `/spend 30m`
   - Add remaining time: `/spend 1h 30m`

## Best Practices

1. **Issue Updates**: Comment on issues regularly to track progress
2. **Link Related Work**: Use `#issue-number` to reference related issues
3. **Move Cards**: Update issue status by moving cards across the board
4. **Track Time**: Log time spent to improve future estimations

## Next Steps

After completing this setup:
1. Review all created issues
2. Prioritize your work
3. Move first issue to "Doing"
4. Start development work

Remember: Good project management makes development smoother and more trackable.
