# Basic Revert

## Setup

1. Run `source setup_basic_revert.sh` to initialize the environment.

## The Task

In this task, some unwanted changes were introduced that we need to remove. Since our history is public, we can't simply change it. Instead, we need to use revert to remove the unwanted changes in a safe way.

1. Use `git log --oneline` to look at the history.
2. Use `cat` to view the content of `greeting.txt`.
3. Use `git revert` on the newest commit to remove the changes the last commit added.
4. Use `git log --oneline` to view the history.
5. Did the revert command add or remove a commit?
6. Use `cat` to view the content of `greeting.txt`.
7. Use `ls` to see the content of the workspace.
8. Use `git log --oneline` to find the SHA of the commit that added credentials to the repository.
9. Use `git revert` to revert the commit that added the credentials.
10. Use `git log --oneline` to view the history.
11. Use `ls` to see the content of the workspace.
12. How many commits were added or changed by the last revert?
13. Use `git show` with the SHA of the commit you reverted to see that the credentials file is still in the history.
14. Now that you've reverted the credentials file and it's removed from your working directory, is it also removed from Git's history?

## Useful Commands

- `git revert <ref>`
- `git log --oneline`
- `git show <ref>`

### [<<Previous](8-branch-rebase.md) &nbsp;&nbsp; [>>Next](10-reset.md)