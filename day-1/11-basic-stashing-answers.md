# Git Kata: Basic Stashing - Answers

## Task Answers

1. Exploring the repo initially:
   1. Working directory changes:
      ```bash
      $ git status
      Changes not staged for commit:
        modified:   file.txt
        modified:   fix.txt
      ```
      The unstaged changes show modifications to both file.txt and fix.txt.

   2. Staged changes:
      ```bash
      $ git status
      Changes staged for commit:
        modified:   file.txt
      ```
      file.txt has staged changes (visible in the staging area/index).

   3. Commit log:
      ```bash
      $ git log --oneline
      abc1234 add bug.txt
      def5678 Initial commit
      ```
      Two commits are present: the initial commit and the bug.txt addition.

2. After using `git stash`:
   1. Working directory:
      ```bash
      $ git status
      On branch main
      nothing to commit, working tree clean
      ```
      All changes (both staged and unstaged) are now stashed away.

   2. Staged changes: None (cleared by stash)

   3. Commit log: Unchanged from before

   4. Stash list:
      ```bash
      $ git stash list
      stash@{0}: WIP on main: abc1234 add bug.txt
      ```
      The stash contains our saved work-in-progress (WIP) state.

3. Fixing bug.txt:
   ```bash
   $ echo "this file has some typos" > bug.txt
   $ git add bug.txt
   $ git commit -m "Fix typos in bug.txt"
   ```
   This creates a new commit fixing the typos.

4. After applying stash (without --index):
   1. Working directory:
      ```bash
      $ git status
      Changes not staged for commit:
        modified:   file.txt
        modified:   fix.txt
      ```
      All changes are present but unstaged.

   2. Staged changes: None
      > This is a key point: `git stash apply` without --index doesn't preserve staging area state.
      > The changes are recovered but need to be re-staged.

5. After reset and applying stash with --index:
   1. Working directory:
      ```bash
      $ git status
      Changes to be committed:
        modified:   file.txt
      Changes not staged for commit:
        modified:   file.txt
        modified:   fix.txt
      ```

   2. Staged changes:
      The original staged changes to file.txt are properly restored to the staging area.
      > The --index option preserves the exact state of both working directory and staging area.

7. After dropping the stash:
   1. Stash list:
      ```bash
      $ git stash list
      # Empty list - no stashes remain
      ```

   2. Commit log:
      ```bash
      $ git log --oneline
      xyz9012 Fix typos in bug.txt
      abc1234 add bug.txt
      def5678 Initial commit
      ```
      Shows the original commits plus our bug fix commit.

## Key Concepts

1. **Stash Storage**:
   - Stashes are stored in a stack (Last-In-First-Out)
   - Each stash contains a complete snapshot of your changes
   - Stashes persist until explicitly dropped

2. **Stash Contents**:
   - Staged changes (index)
   - Unstaged changes (working directory)
   - Untracked files (if specified)
   - The current state of the HEAD commit

3. **Stash Application**:
   - Basic apply (`git stash apply`): Restores only working directory changes
   - Index-aware apply (`git stash apply --index`): Restores both working directory and staging area state

## Best Practices

DO:
- Use descriptive stash messages with `git stash save "message"` for better tracking
- Clean up stashes regularly using `git stash drop` or `git stash clear`
- Verify your stash contents before dropping with `git stash show -p`
- Use `git stash branch <branchname>` if you need to apply stashed changes to a new branch

DON'T:
- Keep stashes for long periods - they should be temporary
- Stash multiple sets of unrelated changes together
- Forget about stashed changes (use `git stash list` regularly)
- Use stash as a substitute for proper branching

## Common Pitfalls and Solutions

1. **Lost Staging State**:
   - Problem: Simple `git stash apply` loses staging information
   - Solution: Use `git stash apply --index` to preserve staging area state

2. **Stash Conflicts**:
   - Problem: Stash application conflicts with current changes
   - Solution: Resolve conflicts manually, similar to merge conflicts

3. **Forgotten Stashes**:
   - Problem: Accumulating too many stashes
   - Solution: Use descriptive messages and clean up regularly

## Tips for Working with Stash

1. **Selective Stashing**:
   ```bash
   git stash push -m "message" file1.txt file2.txt
   ```
   Stash only specific files

2. **Interactive Stashing**:
   ```bash
   git stash -p
   ```
   Choose which changes to stash interactively

3. **Stash Inspection**:
   ```bash
   git stash show -p stash@{0}
   ```
   View detailed contents of a specific stash 