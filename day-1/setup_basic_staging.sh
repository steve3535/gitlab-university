#!/bin/bash

# Clean up previous directory if it exists
rm -rf git-staging-exercise

# Create a new directory for the exercises
mkdir -p git-staging-exercise
cd git-staging-exercise

# Initialize a new Git repository
git init

# Create the initial file
echo "1" > file.txt

# Add and commit the initial file
git add file.txt
git commit -m "Initial commit with file.txt containing '1'"

echo "Environment setup complete. You are in the git-staging-exercise directory."
echo "You can now start the basic staging exercise." 