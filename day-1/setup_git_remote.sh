#!/bin/bash

# Create a directory outside of our current git repository
EXERCISE_DIR=/workspaces/git-remote-exercises
echo "Setting up remote exercises in $EXERCISE_DIR..."

# Cleanup previous exercise
rm -rf $EXERCISE_DIR
mkdir -p $EXERCISE_DIR/my-first-remote

# Create the exercise structure
cd $EXERCISE_DIR

# Instructions for students
echo "
Remote Exercise Setup Complete!

Your working directory is: $EXERCISE_DIR
This directory is OUTSIDE the course repository.

Follow these steps:
1. cd $EXERCISE_DIR
2. Create your first repository:
   mkdir my-first-remote
   cd my-first-remote
   git init
   
3. Create and commit some files
4. Create a new repository on GitHub
5. Follow the lesson instructions to connect and push

Note: You can safely practice all remote operations here without affecting the course repository.
" > README.md

echo "Exercise environment ready at $EXERCISE_DIR"