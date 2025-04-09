# Onboarding Guide

## Pre-Course Setup Guide

### Windows Setup
**Git Installation**
   - Download Git from https://git-scm.com/download/win
   - During installation:
     - Choose "Git Bash" option
     - Select "main" as default branch name
     - Choose "Visual Studio Code" as default editor (or notepad++)
     - Select "Use Git and optional Unix tools"
     - Launch "Git bash"
   
### macOS Setup
**Git Installation**
   - Install via Terminal: `xcode-select --install` (basic)
   - Or via Homebrew: `brew install git` (advanced)
   
### Linux Setup
**Git Installation**
   - Ubuntu/Debian: `sudo apt-get install git`
   - Fedora: `sudo dnf install git`
   - Arch: `sudo pacman -S git`

   
### Exercice: common Setup Steps (All Platforms)

1. **Git Configuration**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```
   > *--global* is used here as we dont yet have a git directory
     
2. **GitHub Account Setup**
   - Create account at github.com
  
3. **Verification**  
   - Git Installation Check
     ```bash
     git --version
     ```
     Expected output: version 2.x or higher

   - Git Configuration Check
     ```bash
     git config --list
     ```
     Verify email and name are correct

4. **Test Repository**
   ```bash
   git init test
   cd test
   git status
   ```

### Labs access    
1. **SSH Key Setup**
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   ```
   > **Make sure you set a passphrase**
   
   1.1. Copy your public key
   ```bash
   # this is an example on Windows with gitbash terminal: the command and the path might be different
   cat /c/Users/PC/.ssh/id_ed25519.pub
   ```
   1.2. Send your public key by email to *steve@thelinuxlabs.com*
   - Specify your github username in the email's object  
     ![sample](./send_ssh_pubkey.png)  
     

3. **Labs access**
   - Go to https://srv1.thelinuxlabs.com 
   - Select github as authentication method
   - Authorize gitlab-self-hosted (steve3535)  
   - Username: <your-github-username>
   - Enter your **private key** and your **passphrase**  
     
## Pre-Course Checklist
- [ ] Git installed and working
- [ ] Test repository created successfully
- [ ] GitHub account created
- [ ] SSH key pair generated and access granted for the labs

### [>>Next](1-introduction.md)
