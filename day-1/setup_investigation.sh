#!/bin/bash

# Clean up previous directory if it exists
rm -rf git-investigation

# Create a new directory for the exercises
mkdir -p git-investigation
cd git-investigation

# Initialize a new Git repository
git init

# Create initial structure
mkdir -p folder1 folder2
echo "Content of file1" > file1
echo "Content of file2" > folder1/file2
echo "Content of file3" > folder2/file3

# First commit - add everything
git add .
git commit -m "Initial commit with file1, folder1/file2, and folder2/file3"

# Create a new branch and make changes on it
git branch feature
git checkout feature

# Make changes on the feature branch
echo "New content for file1 on feature branch" > file1
echo "New file on feature branch" > folder1/file4

# Commit changes on feature branch
git add .
git commit -m "Update file1 and add file4 on feature branch"

# Go back to master and make a different change
git checkout main
echo "Modified content of file1 on master" > file1

# Commit changes on master
git add file1
git commit -m "Update file1 on master branch"

# Create a tag
git tag v1.0

echo "Git investigation environment setup complete. You are in the git-investigation directory."
echo "Repository structure created with branches, commits, and files to explore git objects." 