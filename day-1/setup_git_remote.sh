#!/bin/bash

# Initialize the exercise
EXERCISE_DIR=git-remote
echo "Setting up the exercise..."

# Cleanup previous exercise
rm -rf $EXERCISE_DIR
mkdir -p $EXERCISE_DIR/{remote-demo,project-a,project-b}

# Setup remote-demo repository
cd $EXERCISE_DIR/remote-demo
git init
echo "# Remote Demo Project" > README.md
echo "This is a demonstration of Git remote operations." >> README.md
echo "Initial content" > test.txt
git add README.md test.txt
git commit -m "Initial commit"

# Setup project-a repository
cd ../project-a
git init
echo "# Project A" > README.md
echo "This is Project A for deploy key demonstration." >> README.md
git add README.md
git commit -m "Initial commit for Project A"

# Setup project-b repository
cd ../project-b
git init
echo "# Project B" > README.md
echo "This is Project B for deploy key demonstration." >> README.md
git add README.md
git commit -m "Initial commit for Project B"

echo "Exercise setup completed! Created three repositories:"
echo "1. remote-demo: For basic remote operations"
echo "2. project-a: For deploy key demonstration"
echo "3. project-b: For deploy key demonstration"
echo ""
echo "Next steps:"
echo "1. Create corresponding repositories on GitHub"
echo "2. Follow the lesson instructions to set up remote connections" 