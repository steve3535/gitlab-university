# Branch Rebase

## Setup

1. Run `source setup_branch_rebase.sh` to initialize the environment.

## The Task

You will work with branches to understand how Git's rebase operation works and how it differs from merging.

1. Which branches exist?
2. Look at the log for the `main` branch.
3. Switch to the `uppercase` branch.
4. How does the log compare to the log on the `main` branch?
5. Rebase your `uppercase` branch with the `main` branch (`git rebase main`).
6. What did just happen? Draw it!
7. Now switch to the `main` branch.
8. Merge `uppercase` into `main`.
9. What does the log look like now?

## Useful Commands

- `git switch <branch-name>`
- `git rebase <branch-name>`
- `git log --oneline --graph --all`
- `git merge <branch-name>`

![git rebase](./images/git_rebase.png)

### [Next >>](9-basic-revert.md)
