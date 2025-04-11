#!/bin/bash
# Clean up any existing repositories
rm -rf mergesort

# Create a new repository
mkdir mergesort
cd mergesort
git init

# Add the base implementation
\cp ../mergesort-files/base.py mergesort.py
git add mergesort.py
git commit -m "Fake it till you make it - Faking mergesort using python .sort() method"

# Create a new branch for the mergesort implementation
git checkout -b "Mergesort-Impl"
\cp ../mergesort-files/righty.py mergesort.py
git add mergesort.py
git commit -m "Mergesort implemented on feature branch"

# Switch back to main branch
git checkout main
\cp ../mergesort-files/lefty.py mergesort.py
git add mergesort.py
git commit -m "Mergesort implemented on main"

