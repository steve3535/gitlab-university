# Basic Commits and Staging
This guide will introduce you to the `git add` and `git commit` commands.

## Setup:
1. CD to the training directory: `cd dlh-04-2025/day-1`  
2. Run `source setup_basics.sh`
   - This script will create a `git-basics` directory and switch into it.

**Important:** All Git commands for this exercise **must** be run from *inside* the `git-basics` directory.

## Commits Tasks

1. Use `git status` to see which branch you are on.
2. What does `git log` look like?
3. Create a file named `hello.txt` with some content
4. What does the output from `git status` look like now?
5. `add` the file to the staging area
6. How does `git status` look now?
7. `commit` the file to the repository
8. How does `git status` look now?
9. Change the content of the file you created earlier
10. What does `git status` look like now?
11. `add` the file change
12. What does `git status` look like now?
13. Change the file again
14. Make a `commit`
15. What does the `status` look like now? The `log`?
16. Add and commit the newest change

## Staging Tasks

1. Create a second file named `world.txt` and add some text to it
2. Add both files to the staging area with a single command
3. Make additional changes to `hello.txt`
4. Check the status of your repository
5. Commit your changes
6. Check your commit history with `git log --oneline`

## Useful commands
- `git add`
- `git commit`
- `git commit -m "My commit message"`
- `git log`
- `git log -n 5`
- `git log --oneline`
- `git log --oneline --graph`
- `touch filename` to create a file
- `echo content > file` to overwrite file with content
- `echo content >> file` to append file with content

![git areas](./images/git_basics-areas.excalidraw.png)

## Git Initial Configuration
1. `git config --global user.name "John Doe"`
1. `git config --global user.email "johndoe@example.com"`

For the vim scared:
- `git config --global core.editor nano`

Other editor options:
- `git config --global core.editor "atom --wait"`
- `git config --global core.editor "code --wait"`

