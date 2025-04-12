#!/bin/bash

# Cleanup any previous directory
rm -rf branch-rebase-repo

# Initialize a new Git repository
mkdir branch-rebase-repo
cd branch-rebase-repo
git init

# Create initial file and commit
touch greeting.txt
git add greeting.txt
git commit -m "Add file greeting.txt"

# Add content to greeting.txt and commit
echo "hello" > greeting.txt
git add greeting.txt
git commit -m "Add content to greeting.txt"

# Create and switch to uppercase branch
git checkout -b uppercase
echo "HELLO" > greeting.txt
git commit -am "Change greeting to uppercase"

# Move forward on main branch
git checkout main
echo "Greetings library" > README.md
git add README.md
git commit -m "Add readme"