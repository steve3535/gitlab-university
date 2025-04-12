# Git objects

Objects are stored in `<repository>/.git/objects` in subfolders matching the first two chars of the sha.
`fc1da6e8f` is therefore the file: `.git/objects/fc/1da6e8f`.

`git cat-file` inflates and shows the content of whatever _ref_ you pass it.
`-p` asks `cat-file` to pretty-print the content of an object.
`-t` shows the type of an object (commit, tree, blob, tag).
`-s` shows the size of an object.

`git ls-tree main .` inflates and lists the content of a folder.

## Setup:
0. Day 1: `cd day-1`
1. Run `source setup_investigation.sh` 

## Task

1. Using `git ls-tree` and `git cat-file`, draw the entire Git data structure.
	- What tree and blob objects do you have and what do they point at?
	- What commits point inside this graph and where?

## Examples of useful commands for exploration

```bash
# View the type of an object
git cat-file -t HEAD

# View the commit object
git cat-file -p HEAD

# Examine a specific file in the latest commit
git cat-file -p main:file1

# List the root directory contents
git ls-tree main

# List a subdirectory contents
git ls-tree main:folder1

# Find all objects in the database
find .git/objects -type f | sort
```

### [<<Previous](2-basic-staging.md) &nbsp;&nbsp; [>>Next](4-basic-branching.md)
