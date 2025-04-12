# Git Kata: Basic Stashing - Practical Exercise Summary

## Initial State
We started with:
```bash
$ git status
Changes to be committed:
  modified:   file.txt        # Staged changes

Changes not staged for commit:
  modified:   file.txt        # Additional unstaged changes
  modified:   fix.txt         # Unstaged changes
```

## Step-by-Step Actions and Observations

1. **Stashing Changes**
   ```bash
   $ git stash
   Saved working directory and index state WIP on main: 9c8f859 add bug.txt
   ```
   - All changes (staged and unstaged) were saved
   - Working directory became clean
   - Changes were labeled as "WIP" (Work In Progress)

2. **Verifying Stash**
   ```bash
   $ git stash list
   stash@{0}: WIP on main: 9c8f859 add bug.txt
   ```
   - Stash was saved in the stash stack
   - Reference to the commit we were on was preserved

3. **Fixing the Bug**
   ```bash
   # Fixed bug.txt and committed
   $ git commit -am "fixbug"
   [main 1daa8bf] fixbug
   ```
   - Working on a clean state
   - Fixed the immediate issue
   - Created a proper commit

4. **Applying Stash Without Index**
   ```bash
   $ git stash apply
   ```
   Result:
   - All changes came back as unstaged
   - Lost the original staging state
   - Content was preserved but staging information was lost

5. **Applying Stash With Index**
   ```bash
   $ git stash apply --index
   ```
   Result:
   - Restored exact previous state
   - Staged changes remained staged
   - Unstaged changes remained unstaged

## Key Learnings

1. **Stash Usage Pattern**:
   - Stash when you need to switch context
   - Fix urgent issues with a clean slate
   - Return to your work exactly as you left it

2. **Staging State Preservation**:
   - `git stash apply` - recovers content but loses staging
   - `git stash apply --index` - recovers content AND staging state
   - Always use `--index` if you want to preserve your exact working state

3. **Real-world Application**:
   ```
   Working on feature
         ↓
   Urgent bug reported
         ↓
   Stash changes
         ↓
   Fix bug
         ↓
   Commit fix
         ↓
   Restore changes (with --index)
         ↓
   Continue feature work
   ```

## Best Practice Tips from Exercise

1. **Stashing**:
   - Use `git stash list` to verify your stash was saved
   - Use `git stash show -p` to inspect stash contents
   - Always check status after stashing

2. **Applying Stashes**:
   - Use `--index` to preserve staging area state
   - Verify the restored state matches expectations
   - Remember stashes persist until explicitly dropped

3. **Context Switching**:
   - Stash is perfect for quick context switches
   - Keep commits clean and focused
   - Don't leave stashes hanging around too long

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