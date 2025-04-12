#!/bin/bash

# Cleanup any previous directory
rm -rf reset-exercise

# Initialize a new Git repository
mkdir reset-exercise
cd reset-exercise
git init

# Create multiple numbered files and commit them
for i in {1..10}
do
    echo "Content for file $i" > $i.txt
    git add $i.txt
    git commit -m "Add file $i.txt"
done
