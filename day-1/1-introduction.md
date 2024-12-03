# Module 1: Welcome

## Opening
- Quick round of introductions
- Course objectives overview
- Day's structure and expectations

## Why Version Control?

### The Problem We're Solving
```
document.txt
document_v2.txt
document_final.txt
document_final_FINAL.txt
document_final_FINAL_2.txt
```

### Key Benefits
1. **History**
   - Track what changed
   - Know who changed it
   - Understand why it changed

2. **Collaboration**
   - Work simultaneously
   - Merge changes safely
   - Review others' work

3. **Experimentation**
   - Try new ideas safely
   - Multiple versions in parallel
   - Easy rollback

## Git's Mental Model

### The Three States
1. **Working Directory**
   - Your actual files
   - Where you make changes

2. **Staging Area (Index)**
   - Preparation room
   - Choose what to commit

3. **Repository**
   - History storage
   - Permanent records

Visual Metaphor: "Photography Studio"
- Working Directory = Scene you're photographing
- Staging Area = Setting up the shot
- Repository = Photo album

## Quick Setup Verification

### Command Line Check
```bash
# Check Git installation
git --version

# Verify configuration
git config --get user.name
git config --get user.email

# Test GitHub connection
ssh -T git@github.com
```

### What's Next
- Creating our first repository
- Making our first commit
- Understanding Git's internal model

## Learning Approach
- Learn by doing
- Ask questions anytime
- Mistakes are learning opportunities
- Take notes on commands for reference

## Labs access
- Go to https://srv1.thelinuxlabs.com 
- Select github as authentication method
  * if asked, authorize gitlab-self-hosted (steve3535)  
- Username: devops  
- Enter your **private key** and your passphrase  
- Once logged in, ssh into your environment: `ssh -p 22XX localhost`  
  * XX is an identifier sent to you by email
 
### [<<Previous](0-onboarding.md) &nbsp;&nbsp; [>>Next](2-git-basics-1.md)

