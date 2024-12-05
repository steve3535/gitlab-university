# Git Branching & Merging

## 1. Understanding Branches
A branch in Git is simply a lightweight movable pointer to a commit. Think of it as a separate line of development that allows you to:
- Work on new features without affecting the main code
- Experiment with changes safely
- Collaborate with team members without conflicts

### 1.1 Viewing Branches
```bash
# Create a new directory and initialize Git
mkdir branching-tutorial
cd branching-tutorial
git init
```
```bash
# Create and commit a simple file
echo "# Branching Tutorial" > README.md
git add README.md
git commit -m "Initial commit"
```
```bash
# List all branches
git branch
```
You should see a single branch named `main` or `master` with an asterisk (*) indicating it's your current branch.

## 2. Creating and Switching Branches

### 2.1 Basic Branch Operations
```bash
# Create a new branch from main
git branch feature-login

# Switch to the new branch
git checkout feature-login

# Or create and switch in one command
git checkout -b feature-signup
```

### 2.2 Your First Branch
```bash
# 1. Create a branch named `feature-homepage`
git checkout -b feature-homepage
```
```bash
# 2. Make some changes
echo "<h1>Welcome to Our Site</h1>" > index.html
git add index.html
git commit -m "Add homepage header"
```
```bash
#3. View your branch history
git log --oneline --decorate --graph --all
```

## 3. Working with Multiple Branches

### 3.1 Branch Navigation
```bash
# Come back to main
git checkout main
# Create multiple features
git checkout -b feature-1
echo "Feature 1 content" > feature1.txt
git add feature1.txt
git commit -m "Add feature 1"
```
```bash
git checkout -b feature-2
echo "Feature 2 content" > feature2.txt
git add feature2.txt
git commit -m "Add feature 2"
```
```bash
# Navigate between branches
git checkout feature-1
git checkout feature-2
git checkout main

# Check branches
git branch

# View your branch history
git log --oneline --decorate --graph --all
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
```
```bash
# back to main & Merge
git checkout main
git merge simple-feature
```
```bash
# View your branch history
git log --oneline --decorate --graph --all
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

```bash
# Merge feature into main
git merge complex-feature
```
```bash
# View your branch history
git log --oneline --decorate --graph --all
```

## 5. Handling Merge Conflicts

### 5.1 Creating and Resolving Conflicts
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
```
```bash
# Try to merge
git merge conflict-branch
```  
**Resolve the conflict**:  
1. Open conflict.txt
2. Choose desired changes
3. Remove conflict markers
4. Stage and commit

```bash
git add conflict.txt
git commit -m "Resolve merge conflict"
```
```bash
# View your branch history
git log --oneline --decorate --graph --all
``` 
## 6. Working with Remote Branches
```bash
# Push a local branch to remote for the first time
git push -u origin feature-login
# -u sets up tracking, allowing future git pull/push without specifying branch

# Push changes to an existing remote branch
git push

# Get all remote branches
git fetch origin

# Pull changes from remote branch
git pull origin feature-login
```

## 6.1. Understanding Pull/Merge Requests
A Pull Request (GitHub) or Merge Request (GitLab) is a formal way to:

Propose changes from your branch to main
Review code as a team
Discuss modifications
Ensure quality through peer review
Document why and how changes were made

### 6.2. Creating a Pull Request in GitHub
1. Push your branch
2. Visit GitHub repository
   You'll see a "Compare & pull request" button (appears after pushing)  
   If not visible, click "Pull requests" tab and then "New pull request"  
   Select your branch to compare with main  
3. Fill in the PR template
   Add accurate description, add reviewers, labels, projects, etc.  
4. Click "Create pull request"  
   For work in progress, create a "Draft pull request" instead  
   This prevents accidental merging before ready  

### 6.3 Reviewing Merge Requests
As a reviewer:
1. Check out the branch locally:
```bash
git fetch origin
git checkout origin/feature-1
```
2. Test the changes
3. Review the code
   - Look for:
     - Code quality
     - Potential bugs
     - Documentation
     - Test coverage
   - Add comments inline
   - Suggest changes
4. Approve or Request Changes

### 6.4 Hands-on Team Exercise: Complete Workflow
In your teams of 5:

#### Setup Phase:
1. Team lead:
   ```bash
   # Create new repository on GitHub named 'team-[pseudo]'
   # Initialize with README
   ```

2. All members:
   ```bash
   # Clone the repository
   git clone https://github.com/<your-team-lead-username>/team-[pseudo].git
   ```

#### Development Phase:
1. Create your feature branch:
   ```bash
   git checkout -b feature/[username]-profile
   ```

2. Add your profile:
   ```bash
   mkdir profiles
   echo "# About [Your Name]" > profiles/[username].md
   echo "Role: Developer" >> profiles/[username].md
   echo "Skills: Git, Python, etc." >> profiles/[username].md
   ```

3. Commit and push:
   ```bash
   git add profiles/[username].md
   git commit -m "Add [username]'s profile"
   git push -u origin feature/[username]-profile
   ```

4. Create Pull Request:
   - Title: "Add [username]'s profile"
   - Assign to: Another team member
   - Add label: "profile"

#### Review Phase:
1. Each member reviews one teammate's PR:
   ```bash
   git fetch origin
   git checkout origin/feature/[teammate]-profile
   ```
   
2. Review in GitHub:
   - Add at least one constructive comment
   - Suggest one improvement
   - Approve if changes look good

#### Merge Phase:
1. Address review comments:
   ```bash
   # Make requested changes
   git add profiles/[username].md
   git commit -m "Address review comments"
   git push
   ```

2. Merge after approval:
   - Click "Merge" in GitHub
   - Delete branch after merge (checkbox in UI)

3. Update local main:
   ```bash
   git checkout main
   git pull origin main
   ```

### 6.7 Best Practices for Team Collaboration
1. Always create branches from updated main
2. Push regularly to backup work
3. Keep MRs small and focused
4. Write clear MR descriptions
5. Review thoroughly but kindly
6. Address all review comments
7. Keep main branch clean and stable
8. Delete merged branches


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

## Additional Resources
- Git documentation: https://git-scm.com/doc
- Pro Git book: https://git-scm.com/book/en/v2
