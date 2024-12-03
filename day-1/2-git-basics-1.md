# Project 1: Git 101

## Part A: Basic Git Operations

### Core Commands Overview
#### git init

Creates a new Git repository  
Sets up the necessary directory structure  
Creates the .git directory that stores all Git metadata  

#### git status  

Shows the current state of your working directory  
Displays tracked/untracked files  
Shows staged changes  
Provides helpful hints about possible next steps  

#### git add

Stages changes for commit  
Can add specific files: git add filename  
Can add all changes: **git add .**
Can add parts of files: **git add -p**  

#### git commit

Records staged changes in the repository  
Requires a commit message: **git commit -m "message"**  
Best practices for commit messages:    
- Be specific but concise  
- Use present tense  
- Describe what and why, not how  

#### git log

Shows commit history  
Various useful options:  
**git log --oneline**: Compact view  
**git log --patch**: Show changes in each commit  
**git log --graph**: Visual representation of history  

### Exercise 1: First Repository
```bash
# Create a new project
mkdir my-first-project
cd my-first-project
git init

# Observe initial state
git status
```

### making changes
1. Create a simple Python game starter:
```bash
echo "# Number Guessing Game" > README.md
``` 
```bash
vim game.py
```
```python 
import random

def guess_number():
    number = random.randint(1, 100)
    print("I'm thinking of a number between 1 and 100...")
    
    while True:
        guess = input("Your guess? ")

if __name__ == "__main__":
    guess_number()
```

2. Stage and commit changes:
```bash
# Check status
git status

# Stage files
git add README.md
git add game.py

# Check what's staged
git status

# Create first commit
git commit -m "Initial game setup"
```
Try and run the game:  
```bash
python game.py
```  
### modifying and viewing History
1. Add game logic:
```python
# Add to game.py, just before if __name__ == "__main__":

        try:
            guess = int(guess)
            if guess < number:
                print("Higher!")
            elif guess > number:
                print("Lower!")
            else:
                print("You got it!")
                break
        except ValueError:
            print("Please enter a valid number")

```

2. Track changes:
```bash
# Check what changed
git diff

# Stage and commit
git add game.py
git commit -m "Add game logic"

# View history
git log
git show
```
### Exercise 2: Task Tracker

#### Step 1: New Repository
```bash
mkdir task-tracker
cd task-tracker
git init
```

#### Step 2: Create Task List
```bash
# Create tasks file
echo "# My Task List

## Today
- [ ] Start Git tutorial
- [ ] Practice basic commands
- [ ] Complete first project

## Tomorrow
- [ ] Review Git concepts
- [ ] Share progress with team" > tasks.md
```
```bash
# Check status and stage
git status
git add tasks.md

# Create first commit
git commit -m "Create initial task list with today and tomorrow sections"
```

### Step 3: Update Tasks
```bash
# Update tasks (mark some as complete)
echo "# My Task List

## Today
- [x] Start Git tutorial
- [x] Practice basic commands
- [ ] Complete first project

## Tomorrow
- [ ] Review Git concepts
- [ ] Share progress with team
- [ ] Begin next module" > tasks.md
```
```bash
# Check changes
git status
git diff

# Stage and commit updates
git add tasks.md
# Try diff again
git diff
git diff --cached
# Commit
git commit -m "Update task progress and add new task"
```

### Step 4: Using git add -p (Patch Mode)
```bash
# Update tasks.md with mixed changes
echo "# My Task List

## Today
- [x] Start Git tutorial
- [x] Practice basic commands
- [x] Complete first project
- [ ] Read documentation

## Tomorrow
- [ ] Review Git concepts
- [ ] Share progress with team
- [ ] Begin next module
- [ ] Schedule team meeting

## Future Ideas
- [ ] Create project documentation
- [ ] Set up automated testing
- [ ] Plan release schedule" > tasks.md

# Instead of adding all changes at once, let's review and stage selectively
git add -p tasks.md

# Git will show each change (hunk) and ask what to do:
# Stage this hunk [y,n,q,a,d,j,J,g,/,s,e,?]?
# y - stage this hunk
# n - do not stage this hunk
# q - quit; do not stage this or any remaining hunks
# a - stage this and all remaining hunks
# d - do not stage this or any remaining hunks
# s - split the current hunk into smaller hunks
# e - manually edit the current hunk
# ? - print help

# After selectively staging changes
git status        # See what's staged and what's not
git diff          # See unstaged changes
git diff --staged # See staged changes

# Create commit with only selected changes
git commit -m "Complete today's tasks and add future project ideas"

# Stage and commit remaining changes
git add tasks.md
git commit -m "Add team meeting to tomorrow's schedule"
```

## Key Command Reference
```bash
git init          # Create new repository
git status        # Check current state
git add <file>    # Stage changes
git commit -m ""  # Record changes
git log           # View history
git diff          # See unstaged changes
```

## Questions
1. What's the difference between git add and git commit?
2. Why do we need a staging area?
3. How can you see what changes are staged?
4. What's the difference between git diff and git diff --staged

## Part B: Understanding Git's Data Model

### Core Concepts Introduction
- Git as a content-addressable filesystem
- Objects: blobs, trees, commits
- References and HEAD

### Hands-on Demo: Exploring Git's Internals
```bash
# Create a new repository
mkdir git-internals
cd git-internals
git init

# Examining .git directory
ls -la .git/
tree .git/  

# Create content and examine objects
echo "Hello, Git!" > hello.txt
git add hello.txt

# Look at the object created (will show actual hash)
find .git/objects -type f

# Compare with the output of this:
git hash-object hello.txt
```

#### Exploring Git's Storage 

```bash
# Create some file and commit
echo "some content" > file.txt
git add .
git commit -m 'dummy file'
# Look at objects
git cat-file -p HEAD
git cat-file -p main  # or master, depending on default branch
```
**HEAD**  
Simply put, HEAD is a pointer to your current location in your Git history  
It usually points to the latest commit in your current branch  
Think of it as a "You are here" marker in your Git history  
```bash
# See where HEAD points to
git log --oneline
# abc1234 (HEAD -> main) Latest commit
# def5678 Previous commit
# ghi9012 First commit

# HEAD can also be used as a reference point:
HEAD      # Current commit
HEAD^     # Parent of HEAD (one commit back)
HEAD~1    # Same as HEAD^ (one commit back)
HEAD~2    # Two commits back
```
**git ls-files**
Shows you what files Git is tracking in your working directory  
Useful to see what Git "knows about" in your project  

**git ls-tree**
Shows the contents of a tree object in Git  
A tree object represents a directory in Git's storage  
Shows how Git actually stores your project structure  

## Questions

1. Git Directory Structure  
   what happens if you delete .git ?
2. Use git log --oneline for compact history view
3. Try git log --graph for visual representation <br />
<br />
### [<<Previous](1-introduction.md) &nbsp;&nbsp;[>>Next](3-git-basics-2.md)  
