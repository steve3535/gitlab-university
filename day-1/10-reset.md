# Git Reset

## Introduction

Git reset is a powerful command that can manipulate history. However, it should only be used with local history, as publicly released commits should be considered immutable.

While commonly used to unstage changes, reset has several modes with different effects on your repository state.

## Setup

1. Run `source setup_reset.sh` to initialize the environment.

## Task

1. How does your working directory look like?
2. What does your log look like? What does your stage look like?
3. Run `git reset --soft HEAD~1`
   - What happens to your working directory, your log and your stage?
4. Run `git reset --mixed HEAD~1`
   - What happens to your working directory, your log and your stage?
5. Run `git reset --hard HEAD~1`
   - What happens to your working directory, your log and your stage?
6. Now try to use `git revert HEAD~1`
   - What happens to your working directory, your log and your stage?

## Useful Commands

- `git log --oneline`
- `git commit --amend`
- `git status`
- `git reset --soft`
- `git reset --mixed`
- `git reset --hard`
- `git revert`

## Further Explanation

The reset command overwrites these three trees in a specific order, stopping when you tell it to:
1. Move what the branch HEAD points to (stop here if `--soft`)
2. Make the stage look like HEAD (stop here unless `--hard`)
3. Make the working directory look like the stage

### [<<Previous](9-basic-revert.md) &nbsp;&nbsp; [>>Next](11-basic-stashing.md)
