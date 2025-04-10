#!/bin/bash

# Clean up previous directory if it exists
rm -rf git-basic-branching

# Create a new directory for the exercises
mkdir -p git-basic-branching
cd git-basic-branching

# Initialize a new Git repository
git init

# Configure user for this repo
git config user.name "Git Student"
git config user.email "student@example.com"

# Rename the default branch to main (in case it's not already)
git checkout -b main 2>/dev/null || git checkout main

# Create a dummy file and commit it
echo "dummy" > dummy.txt
git add dummy.txt
git commit -m "dummy commit"

# Create a second branch
git checkout -b second-branch

# Return to main branch
git checkout main

echo "Environment setup complete. You are in the git-basic-branching directory."
echo "You can now start the basic branching exercises." 