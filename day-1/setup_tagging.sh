#!/bin/bash

# Initialize the exercise
EXERCISE_DIR=git-tagging
echo "Setting up the exercise..."

# Cleanup previous exercise
rm -rf $EXERCISE_DIR
mkdir $EXERCISE_DIR
cd $EXERCISE_DIR
git init

# Create initial commit with a feature
echo "Initial feature implementation" > feature.txt
git add feature.txt
git commit -m "Initial commit: Basic feature implementation"

# Add some improvements
echo "Added error handling" >> feature.txt
git add feature.txt
git commit -m "Added error handling"

# Add a major feature
echo "Added new functionality" >> feature.txt
git add feature.txt
git commit -m "Added major new functionality"

# Create a config file
echo "version: 1.0" > config.yml
git add config.yml
git commit -m "Added configuration file"

# Add documentation
echo "# Project Documentation" > README.md
echo "This project demonstrates Git tagging." >> README.md
git add README.md
git commit -m "Added documentation"

echo "Exercise setup completed!"