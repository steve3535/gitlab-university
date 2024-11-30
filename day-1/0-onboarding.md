# Onboarding Guide

## Pre-Course Setup Guide

### Windows Setup
**Git Installation**
   - Download Git from https://git-scm.com/download/win
   - During installation:
     - Choose "Git Bash" option
     - Select "main" as default branch name
     - Choose "Visual Studio Code" as default editor (or notepad if preferred)    
   
### macOS Setup
**Git Installation**
   - Install via Terminal: `xcode-select --install` (basic)
   - Or via Homebrew: `brew install git` (advanced)
   
### Linux Setup
**Git Installation**
   - Ubuntu/Debian: `sudo apt-get install git`
   - Fedora: `sudo dnf install git`
   - Arch: `sudo pacman -S git`
   
### Common Setup Steps (All Platforms)

1. **Git Configuration**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
   
2. **GitHub Account Setup**
   - Create account at github.com
     
3. **SSH Key Setup**
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ``` 
   
## Verification Steps

### 1. Git Installation Check
```bash
git --version
```
Expected output: version 2.x or higher

### 2. Git Configuration Check
```bash
git config --list
```
Verify email and name are correct

### 3. GitHub SSH Check
```bash
ssh -T git@github.com
```
Should see successful authentication message

### 4. Test Repository
```bash
git init test
cd test
git status
```

## Pre-Course Checklist
- [ ] Git installed and working
- [ ] GitHub account created
- [ ] SSH key added to GitHub
- [ ] Test repository created successfully
