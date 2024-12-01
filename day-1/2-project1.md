# Project 1: Local Git Mastery

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

### Exercise 2: Making Changes
1. Create a simple Python game starter:
```bash
echo "# Number Guessing Game" > README.md
``` 
```bash
vim game.py
``` 
import random

def guess_number():
    number = random.randint(1, 100)
    print("I'm thinking of a number between 1 and 100...")
    
    while True:
        guess = input("Your guess? ")
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
### Exercise 3: Modifying and Viewing History
1. Add game logic:
```bash
# Add to game.py
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

if __name__ == "__main__":
    guess_number()
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

## Part B: Understanding Git's Data Model (15 minutes)

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
tree .git/  # (or dir /a .git on Windows)

# Create content and examine objects
echo "Hello, Git!" > hello.txt
git add hello.txt

# Look at the object created (will show actual hash)
find .git/objects -type f
```


## Part C: Understanding Git's Storage (10 minutes)

### Exploring Git Objects
```bash
# Look at objects
git cat-file -p HEAD
git cat-file -p main  # or master, depending on default branch
```

### Key Concepts to Observe
- Commit objects and their structure
- Tree objects and file tracking
- Blob storage and content addressing

## Learning Outcomes Verification
Students should be able to:
- Initialize a new Git repository
- Create and stage changes
- Create meaningful commits
- View and understand repository history
- Explain basic Git object types

## Common Pitfalls and Learning Moments
1. Staging vs. Committing
   - Try to commit before staging (show error)
   - Understand the two-step process

2. Git Directory Structure
   - Show what happens if you delete .git
   - Demonstrate repository vs. regular directory

3. Commit Messages
   - Practice writing clear, descriptive messages
   - Show impact of good vs. poor commit messages

## Extension Activities (if time permits)
- Examine object hashes and their relationship
- Create multiple commits and view the chain
- Use git log --oneline for compact history view
- Try git log --graph for visual representation
