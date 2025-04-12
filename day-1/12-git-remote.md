# Git Remote Operations

## Setup:

1. Run `source setup_git_remote.sh`
   - This will create a separate working directory for remote exercises
   - The exercises will be performed OUTSIDE the course repository
   - This allows you to practice real remote operations safely

## The Task

You will create and manage multiple remote repositories to learn essential remote operations and collaboration patterns.

### Part 1: Basic Remote Setup and Authentication

1. Navigate to your exercise directory:
   ```bash
   cd my-first-remote
   ```

2. Create your first repository:
   ```bash
   # Initialize repository
   git init
   
   # Create some content
   echo "# My First Remote Repository" > README.md
   echo "Initial content" > file1.txt
   
   # Commit changes
   git add README.md file1.txt
   git commit -m "Initial commit"
   ```

3. Create a GitHub repository:
   - Go to GitHub.com
   - Click "New Repository"
   - Name: "my-first-remote"
   - Description: "Learning Git remote operations"
   - Keep it public
   - DO NOT initialize with README

4. First Push Attempt (Learning Moment):
   ```bash
   # Add remote using HTTPS URL
   git remote add origin https://github.com/<username>/my-first-remote.git
   
   # Try to push (this will fail)
   git push -u origin main
   ```
   
   You'll notice this fails! GitHub no longer accepts password authentication for HTTPS. 
   Let's set up proper SSH authentication:

5. SSH Key Setup:
   ```bash
   # Generate SSH key if you don't have one
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Start ssh-agent
   eval "$(ssh-agent -s)"
   
   # Add your key
   ssh-add ~/.ssh/id_ed25519
   
   # Display your public key (you'll need this for GitHub)
   cat ~/.ssh/id_ed25519.pub
   ```

6. Add SSH Key to GitHub:
   - Go to GitHub Settings → SSH and GPG keys
   - Click "New SSH key"
   - Give it a meaningful title (e.g., "My Development Machine")
   - Paste your public key
   - Click "Add SSH key"

7. Update Remote and Push:
   ```bash
   # Remove the HTTPS remote
   git remote remove origin
   
   # Add new remote using SSH URL
   git remote add origin git@github.com:<username>/my-first-remote.git
   
   # Test SSH connection
   ssh -T git@github.com
   
   # Push your changes (this should work now!)
   git push -u origin main
   ```

### Part 2: Collaboration Exercise

1. Find a partner in the class

2. Repository Owner:
   ```bash
   # Create new repository
   cd $HOME/git-remote-exercises
   mkdir collaboration-demo
   cd collaboration-demo
   git init
   
   # Add content
   echo "# Collaboration Project" > README.md
   echo "This is a shared project" > shared.txt
   
   # Commit and push
   git add .
   git commit -m "Initial setup for collaboration"
   ```
   - Create GitHub repository named "collaboration-demo"
   - Add your partner as a collaborator in GitHub settings
   - Push using SSH URL:
     ```bash
     git remote add origin git@github.com:<username>/collaboration-demo.git
     git push -u origin main
     ```

3. Partner's Tasks:
   ```bash
   # Clone the repository (using SSH URL)
   git clone git@github.com:<partner-username>/collaboration-demo.git
   cd collaboration-demo
   
   # Create new feature
   echo "Partner's contribution" > feature.txt
   git add feature.txt
   git commit -m "Add new feature"
   
   # Push changes
   git push origin main
   ```

4. Original Owner:
   ```bash
   # Get partner's changes
   git pull origin main
   
   # View new content
   cat feature.txt
   ```

### Part 3: Advanced Authentication Methods

1. Personal Access Tokens (PAT):
   - Useful for automation and scripts
   - Go to GitHub Settings → Developer Settings → Personal Access Tokens
   - Generate new token with repo scope
   - Store securely for future use

2. Deploy Keys (Repository-specific):
   ```bash
   # Generate deploy key
   ssh-keygen -t ed25519 -f ~/.ssh/deploy_key -C "deploy key"
   
   # Add to repository settings (Deploy Keys section)
   cat ~/.ssh/deploy_key.pub
   ```
   - Use deploy keys for single-repository access
   - Useful for CI/CD systems or deployment servers

### Part 4: Advanced Operations

1. Fetching vs. Pulling:
   ```bash
   # Fetch changes without merging
   git fetch origin
   
   # View changes
   git log origin/main
   
   # Compare with local
   git diff main origin/main
   
   # Merge if happy
   git merge origin/main
   ```

2. Managing Multiple Remotes:
   ```bash
   # Add another remote
   git remote add upstream <original-repo-url>
   
   # List remotes
   git remote -v
   
   # Fetch from specific remote
   git fetch upstream
   
   # Pull from upstream
   git pull upstream main
   ```

## Useful Commands

- `git remote add <name> <url>` - Add a remote
- `git remote -v` - List remotes
- `git push -u <remote> <branch>` - Push and set upstream
- `git fetch <remote>` - Download changes
- `git pull <remote> <branch>` - Fetch and merge changes
- `git remote show <remote>` - Inspect a remote
- `git remote rename <old> <new>` - Rename a remote
- `git remote remove <name>` - Remove a remote

## Tips and Best Practices

1. **Authentication**:
   - Always use SSH keys for personal development
   - Use deploy keys for single-repository automation
   - Use PATs for scripts that need multi-repo access
   - Never share private keys or tokens

2. **Collaboration**:
   - Always pull before pushing
   - Use meaningful commit messages
   - Communicate with team members

3. **Security**:
   - Never commit sensitive data
   - Use .gitignore for secrets
   - Review access permissions regularly
   - Rotate deploy keys and PATs periodically

4. **Maintenance**:
   - Clean up old remotes
   - Verify remote URLs
   - Keep local repos in sync
   - Regularly verify SSH key access

## Common Issues and Solutions

1. **SSH Key Issues**:
   ```bash
   # Test SSH connection
   ssh -T git@github.com
   
   # Check SSH agent
   eval "$(ssh-agent -s)"
   ssh-add -l
   
   # Add key if needed
   ssh-add ~/.ssh/id_ed25519
   ```

2. **Push Rejected**:
   ```bash
   # Remote has changes you don't have
   git pull origin main
   # Resolve any conflicts
   git push origin main
   ```

3. **Remote Not Found**:
   ```bash
   # Verify remote configuration
   git remote -v
   # Re-add if necessary
   git remote remove origin
   git remote add origin git@github.com:<username>/repo.git
   ```

### [<<Previous](11-basic-stashing.md) &nbsp;&nbsp; [>>Next](13-git-tags.md)

