#!/bin/bash

# Initialize the exercise
EXERCISE_DIR=basic-stashing
echo "Setting up the exercise..."

# Cleanup previous exercise
rm -rf $EXERCISE_DIR
mkdir $EXERCISE_DIR
cd $EXERCISE_DIR
git init

# Create initial commit with file.txt and fix.txt
echo "Initial content of the file" > file.txt
touch fix.txt

git add file.txt fix.txt
git commit -m "Initial commit"

# Add bug.txt with typos
echo "this file haaasss some typos" > bug.txt

git add bug.txt
git commit -m "add bug.txt"

# Create staged changes in file.txt
echo "some changes I made and staged" >> file.txt
git add file.txt

# Create unstaged changes in file.txt and fix.txt
echo "some changes I made and did not stage yet" >> file.txt
echo "changes I did not stage" > fix.txt

echo "Exercise setup completed!"