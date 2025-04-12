#!/bin/bash

# Cleanup any previous directory
rm -rf basic-revert-repo

# Initialize a new Git repository
mkdir basic-revert-repo
cd basic-revert-repo
git init

# Create initial file and commit
touch greeting.txt
git add greeting.txt
git commit -m "Add file greeting.txt"

# Add credentials file (simulating a mistake)
echo "supersecretpassword" > credentials.txt
git add credentials.txt
git commit -m "Add credentials to repository"

# Add content to greeting.txt
echo "Original file content" > greeting.txt
git add greeting.txt
git commit -m "Add content to greeting.txt"

# Overwrite greeting.txt (simulating another mistake)
echo "This should have been appended to the original content, rather than overwriting it." > greeting.txt
git add greeting.txt
git commit -m "Overwrite greeting.txt"

