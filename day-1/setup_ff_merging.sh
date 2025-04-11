#!/bin/bash

# Cleanup any previous directory
rm -rf 3way-merge-repo

# Initialize a new Git repository
git init 3way-merge-repo
cd 3way-merge-repo

# Create and commit a base file
touch greeting.txt
git add greeting.txt
git commit -m "Add file greeting.txt"

# Add content to greeting.txt and commit
echo "hello" > greeting.txt
git add greeting.txt
git commit -m "Add content to greeting.txt"

echo "Environment setup complete. You are in the 3way-merge-repo directory."
echo "You can now start the 3-way merge exercises." 