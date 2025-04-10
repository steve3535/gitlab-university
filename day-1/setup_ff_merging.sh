#!/bin/bash

# Clean up previous directory if it exists
rm -rf git-ff-merge

# Create a new directory for the exercises
mkdir -p git-ff-merge
cd git-ff-merge

# Initialize a new Git repository
git init

# Configure user for this repo
git config user.name "Git Student"
git config user.email "student@example.com"

# Rename the default branch to main (in case it's not already)
git checkout -b main 2>/dev/null || git checkout main

# Create the initial file and first commit
echo "hello world" > greeting.txt
git add greeting.txt
git commit -m "Initial commit with greeting.txt"

echo "Environment setup complete. You are in the git-ff-merge directory."
echo "You can now start the fast-forward merging exercises." 