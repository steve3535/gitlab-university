# Git Branching: From Fundamentals to Team Collaboration

## 1. Understanding Branches
A branch in Git is simply a lightweight movable pointer to a commit. Think of it as a separate line of development that allows you to:
- Work on new features without affecting the main code
- Experiment with changes safely
- Collaborate with team members without conflicts

### 1.1 Hands-on Exercise: Viewing Branches
```bash
# Create a new directory and initialize Git
mkdir branching-tutorial
cd branching-tutorial
git init

# Create and commit a simple file
echo "# Branching Tutorial" > README.md
git add README.md
git commit -m "Initial commit"

# List all branches
git branch
```
You should see a single branch named `main` or `master` with an asterisk (*) indicating it's your current branch.

## 2. Creating and Switching Branches

### 2.1 Basic Branch Operations
```bash
# Create a new branch
git branch feature-login

# Switch to the new branch
git checkout feature-login

# Or create and switch in one command
git checkout -b feature-signup
```

### 2.2 Hands-on Exercise: Your First Branch
1. Create a branch named `feature-homepage`
```bash
git checkout -b feature-homepage
```

2. Make some changes
```bash
echo "<h1>Welcome to Our Site</h1>" > index.html
git add index.html
git commit -m "Add homepage header"
```

3. View your branch history
```bash
git log --oneline --decorate --graph --all
```

## 3. Working with Multiple Branches

### 3.1 Hands-on Exercise: Branch Navigation
```bash
# Create multiple features
git checkout -b feature-1
echo "Feature 1 content" > feature1.txt
git add feature1.txt
git commit -m "Add feature 1"

git checkout -b feature-2
echo "Feature 2 content" > feature2.txt
git add feature2.txt
git commit -m "Add feature 2"

# Navigate between branches
git checkout feature-1
git checkout feature-2
git checkout main
```

## 4. Merging Branches

### 4.1 Fast-Forward Merge
When there are no new changes in the target branch, Git performs a fast-forward merge.

```bash
# Create and switch to feature branch
git checkout -b simple-feature
echo "New feature" > feature.txt
git add feature.txt
git commit -m "Add simple feature"

# Merge back to main
git checkout main
git merge simple-feature
```

### 4.2 Three-Way Merge
When both branches have new commits, Git creates a merge commit.

```bash
# Create feature branch
git checkout -b complex-feature
echo "Complex feature" > complex.txt
git add complex.txt
git commit -m "Add complex feature"

# Make changes in main
git checkout main
echo "Main changes" > main.txt
git add main.txt
git commit -m "Add main changes"

# Merge feature into main
git merge complex-feature
```

## 5. Handling Merge Conflicts

### 5.1 Hands-on Exercise: Creating and Resolving Conflicts
```bash
# Create a conflict scenario
git checkout -b conflict-branch
echo "Branch version" > conflict.txt
git add conflict.txt
git commit -m "Branch version"

git checkout main
echo "Main version" > conflict.txt
git add conflict.txt
git commit -m "Main version"

# Try to merge
git merge conflict-branch
```

Resolve the conflict:
1. Open conflict.txt
2. Choose desired changes
3. Remove conflict markers
4. Stage and commit

```bash
git add conflict.txt
git commit -m "Resolve merge conflict"
```

## 6. Team Collaboration Workflows

### 6.1 Feature Branch Workflow
Best for small teams (4-5 members):
1. Create feature branch from main
2. Develop feature
3. Push branch to remote
4. Create Pull/Merge Request
5. Review and merge

```bash
# Example workflow
git checkout -b feature-auth
# Make changes
git add .
git commit -m "Implement authentication"
git push -u origin feature-auth
```

### 6.2 Hands-on Team Exercise
In your teams of 5:
1. Each member creates a feature branch
2. Add a file with your name
3. Push your branch
4. Create merge requests
5. Review each other's code

## 7. Branch Management

### 7.1 Cleaning Up Branches
```bash
# Delete local branch
git branch -d feature-complete

# Delete remote branch
git push origin --delete feature-complete

# Prune deleted remote branches
git fetch --prune
```

### 7.2 Branch Naming Conventions
Follow these patterns:
- feature/feature-name
- bugfix/bug-description
- hotfix/fix-description
- release/version-number

## 8. Advanced Topics

### 8.1 Rebasing
```bash
# Interactive rebase
git checkout feature-branch
git rebase -i main

# Squash commits
git rebase -i HEAD~3
```

### 8.2 Cherry-picking
```bash
# Apply specific commits to current branch
git cherry-pick commit-hash
```

## Practice Exercises
1. Individual Exercise:
   - Create 3 feature branches
   - Make changes in each
   - Merge them back to main
   - Resolve any conflicts

2. Team Exercise:
   - Each team member creates a branch
   - Implement a small feature
   - Create merge requests
   - Review and merge all changes

## Common Issues and Solutions
1. Cannot switch branches:
   - Stash or commit changes first
   ```bash
   git stash
   git checkout other-branch
   git stash pop
   ```

2. Merge conflicts:
   - Always pull latest changes before starting new work
   - Communicate with team about file changes
   - Use git status to check conflict files

## Best Practices
1. Always create branches from updated main
2. Keep branches focused and short-lived
3. Write clear commit messages
4. Review code before merging
5. Delete branches after merging
6. Regular pulls from main to avoid conflicts

## Review Questions
1. What is a branch and why do we use them?
2. How do you create and switch branches?
3. What's the difference between merge and rebase?
4. How do you resolve merge conflicts?
5. What's the team workflow for feature development?

## Additional Resources
- Git documentation: https://git-scm.com/doc
- Git branching visualization: https://learngitbranching.js.org/
- Pro Git book: https://git-scm.com/book/en/v2
