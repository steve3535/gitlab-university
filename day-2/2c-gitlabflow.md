# GitLab Flow Hands-on Exercise

## Overview
This hands-on exercise will guide you through implementing a feature using GitLab flow - a proven workflow methodology for efficient software development. You'll simulate the complete development lifecycle of a new feature, from issue creation to final merge.

## Scenario

![shoes for dog](./images/shoesfordogs.png)

You are working on the "Shoes for Dogs" web application. Your task is to implement a new feature that allows users to filter dog shoes by dog size. While no actual coding is required, you'll go through all the steps of the GitLab flow process.

## Prerequisites
- Access to the GitLab instance
- Create a project (internal or public) in your workspace with the name **shoes-for-dog**  

# GitLab Flow Exercise - Team Structure

Each team must add both reviewers to their project as developers:
1. Go to Project Settings > Members
2. Add reviewer: @michael (Developer role)
3. Add reviewer: @emma (Developer role)

## Project Teams

### Team 1: "shoes-for-dogs-team1"
- Student 1: Project Owner
  - Creates initial issue
  - Sets up project
  - Manages overall flow
  - Student 2: Backend Developer
  - Implements initial backend features
  - Works with reviewers
  - Sets up CI/CD pipeline
- Student 3: Frontend Developer
  - Takes over after backend completion
  - Completes frontend implementation

### Team 2: "shoes-for-dogs-team2"
- Student 4: Project Owner
- Student 5: Backend Developer
- Student 6: Frontend Developer

etc...  

## Role Responsibilities

## Team Summary Table

| Team | Project Owner | Backend Developer | Frontend Developer |
|------|---------------|-------------------|-------------------|
| Team 1 | Student 1 | Student 2 | Student 3 |
| Team 2 | Student 4 | Student 5 | Student 6 |
| Team 3 | Student 7 | Student 8 | Student 9 |
| Team 4 | Student 10 | Student 11 | Student 12 |


## Exercise Tasks

### Initial Setup and Planning Phase

#### Task 1: Create Feature Issue
- Navigate to the Issues section in the project
- Create a new issue titled "Filter shoes by dog size"
- Leave all metadata fields empty initially

#### Task 2: Gather Initial Feedback
- First, invite two other students as project members:
  1. On the left sidebar, go to "Manage > Members"
  2. Click "Invite members"
  3. Enter the usernames or email addresses of two classmates
  4. Set their role to "Maintainer" for the backend developer and to "Developer" for the frontend dev
  5. Click "Invite"
- In the issue's discussion section:
  1. Use @ to mention the two team members you just invited
  2. Add a brief message asking for their thoughts on the feature
  3. Verify that their names appear as clickable mentions

#### Task 3: Process Feedback
- Monitor the discussion section
- Observe one team member adding an emoji reaction
- Review another member's suggestion about additional filtering criteria

#### Task 4: Handle Related Concerns
- Create a new issue titled "Question: what criteria should we use when filtering dog shoes?"
- Link it to the original issue
- Focus on the size filter feature for now

#### Task 5: Planning Meeting Implementation
- Set the issue weight to 8 (representing a 1-week task)
- Assign the issue to backend developer
- Set the due date to 2 weeks from today

### Development Phase

#### Task 6: Issue Organization [Backend developper]
- Apply the scoped label "Status::In Progress"
- Add the unscoped label "backend"
- Verify both labels are visible on the issue

#### Task 7: Setup Base CI/CD Pipeline
- Ensure you are on the main branch
- Create a file named `.gitlab-ci.yml` in the main branch
- Add the following basic pipeline configuration:
```yaml
stages:
  - test
  - security
  - quality

dummy_test:
  stage: test
  script:
    - echo "Running tests..."
    - sleep 10
    - echo "Tests passed!"

security_scan:
  stage: security
  script:
    - echo "Running security checks..."
    - sleep 5
    - echo "No security issues found!"

code_quality:
  stage: quality
  script:
    - echo "Checking code quality..."
    - sleep 5
    - echo "Code quality checks passed!"
```
- Commit this file with the message "Add CI/CD pipeline configuration"
- Wait for the pipeline to start running (it should appear in the CI/CD > Pipelines section)
- Verify the pipeline runs successfully on main

#### Task 8: Feature Branch Creation
- Create a new branch named "filter-shoes-by-size" from main
- Verify that your new branch has inherited the CI/CD configuration

#### Task 9: Merge Request Setup
- Create a new merge request
- Title it "Draft: Filter shoes by dog size"
- Invite the two reviewers, Michael and Emma, as project members (follow same steps as in Task 2)
- Add reviewers:
  1. Initially select Michael as the reviewer when creating the MR
  2. After creating the MR, click on the right sidebar
  3. In the "Reviewers" section, click "Edit"
  4. Add Emma as an additional reviewer
- Verify both Michael and Emma are listed as reviewers in the sidebar

#### Task 10: Development Kickoff
- Add a comment in the merge request
- Indicate that development has started
- Tag the assigned reviewers

#### Task 11: Initial Implementation
- Create a commit with a message describing the initial implementation
- No actual code needed, focus on the commit message
- Example: "Add initial structure for size filtering feature"

#### Task 12: CI/CD Review
- Check the merge request for automated test results
- Verify that all checks have passed
- Review any generated reports

### Review and Iteration Phase

#### Task 13: Code Review Process
- As Michael and Emma, add review comments
- Suggest theoretical improvements
- Focus on architectural and design aspects

#### Task 14: Implementation Discussion
- Respond to review comments
- Engage in discussion about suggested changes
- Document agreed-upon solutions
- Add a commit message reflecting the agreements

#### Task 15: Security Considerations
- Add a commit addressing a theoretical security concern
- Verify that security scans pass
- Document the security improvement

#### Task 16: Frontend Handoff
- Remove the "Backend" label
- Add the "Frontend" label
- Reassign the issue to frontend developer
- Add a handoff comment with relevant information

### Frontend Implementation Phase

#### Task 17: Frontend Development [Frontend developer]
- add frontend-related commit messages
- Request reviews from Michael and Emma
- Respond to any frontend-specific feedback

#### Task 18: Progress Monitoring
- Add "At Risk" label if falling behind schedule
- Project owner assigns another developper to help
- Document the team expansion in the issue

#### Task 19: Completion Phase
- Add final commits
- Remove "At Risk" label
- Obtain final approvals from Michael and Emma
- Ensure all discussions are resolved

### Final Review and Merge Phase

#### Task 20: Production Preparation
- Remove "Draft:" from the merge request title
- Verify all requirements are met
- Update the merge request description if needed

#### Task 21: Final Approvals
- Mention security and QA teams in the merge request
- Wait for their review
- Address any final concerns

#### Task 22: Merge Process
- Confirm all required approvals are received
- Remove "Frontend" and "Status::In Progress" labels
- Complete the merge

#### Task 23: Celebration
- Add a final comment celebrating the completion
- Share a virtual high-five emoji 🖐
- Close the issue

## Notes
- Focus on understanding the workflow rather than actual code
- Notice how GitLab flow maintains organization and transparency

## Tips
- Keep the issue and merge request descriptions clear and detailed
- Use proper Git commit message conventions

## [<<Previous](2b-projects.md) &nbsp;&nbsp; [>>Next](./2d-gitlab-stages.md)
