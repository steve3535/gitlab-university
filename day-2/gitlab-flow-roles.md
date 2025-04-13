# GitLab Flow Exercise - Team Structure

## Group Structure
All projects will be created under the course group:
```
gitlab.university/git-course-2024/
├── course-bots/
│   ├── bot-reviewer1
│   ├── bot-reviewer2
│   └── bot-support
├── team1/shoes-for-dogs-team1
├── team2/shoes-for-dogs-team2
├── team3/shoes-for-dogs-team3
└── team4/shoes-for-dogs-team4
```

## Bot Accounts Setup (Admin Configuration)
1. Create bot user accounts:
   ```bash
   # Create users with specific email domains
   bot-reviewer1@gitlab.university
   bot-reviewer2@gitlab.university
   bot-support@gitlab.university
   ```

2. Configure bot permissions:
   - Add bots to course-bots group as maintainers
   - Set up group-level access tokens
   - Configure merge request approval rules

3. Bot account features:
   - Protected usernames (prevent student use)
   - Automated review comments via CI/CD
   - Merge request approval rules
   - Security scan reports
   - Code quality checks

## Project Creation Instructions (For Students)
1. Create project under the course group:
   ```
   git-course-2024/team1/shoes-for-dogs-team1
   ```
2. Bot accounts will automatically be:
   - Added as project members
   - Set up as required reviewers
   - Configured for automated checks

## Reviewers
Two fixed reviewer accounts will be used across all projects:
- @michael (michael@gitlab.university): First reviewer
- @emma (emma@gitlab.university): Second reviewer

Each team must add both reviewers to their project as developers:
1. Go to Project Settings > Members
2. Add member: @michael (Developer role)
3. Add member: @emma (Developer role)

## Project Teams

### Team 1: "shoes-for-dogs-team1"
- Student 1: Project Owner
  - Creates initial issue
  - Sets up project
  - Manages overall flow
  - Adds Michael and Emma as project members
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

### Team 3: "shoes-for-dogs-team3"
- Student 7: Project Owner
- Student 8: Backend Developer
- Student 9: Frontend Developer

### Team 4: "shoes-for-dogs-team4"
- Student 10: Project Owner
- Student 11: Backend Developer
- Student 12: Frontend Developer

## Role Responsibilities

### Project Owner
- Creates initial feature issue
- Manages project setup
- Coordinates between team members
- Ensures workflow is followed
- Reviews final implementation
- Responsible for final merge decisions
- Adds Michael and Emma as project members

### Backend Developer
- Takes ownership of initial implementation
- Creates feature branch
- Sets up CI/CD pipeline
- Implements backend features
- Coordinates with reviewers
- Handles security considerations

### Frontend Developer
- Implements UI components
- Ensures responsive design
- Coordinates with reviewers
- Works with backend developer
- Prepares for final merge

### Reviewers (Michael and Emma)
- Review all merge requests
- Provide feedback on implementation
- Verify CI/CD pipeline results
- Check code quality
- Ensure security standards
- Must both approve before merging

## Tips for Success
1. Communicate clearly within your team
2. Always assign both Michael and Emma as reviewers
3. Follow the GitLab flow process strictly
4. Document your work for team visibility
5. Keep your team updated on progress
6. Wait for both reviewers' approval before merging

## Team Summary Table

| Team | Project Owner | Backend Developer | Frontend Developer |
|------|---------------|-------------------|-------------------|
| Team 1 | Student 1 | Student 2 | Student 3 |
| Team 2 | Student 4 | Student 5 | Student 6 |
| Team 3 | Student 7 | Student 8 | Student 9 |
| Team 4 | Student 10 | Student 11 | Student 12 |
