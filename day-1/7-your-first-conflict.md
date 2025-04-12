# Merge Conflicts
you will be facing your first merge conflict!
There will be two different branches:

* Mergesort-Impl
* main

The task is to look at the merge conflict, and solve it by editing the file accordingly.

## Setup:

1. Run `source setup_merge_conflict.sh`

## The task

1. Run `git branch` to see the two branches present
2. Merge `Mergesort-Impl` into `master`
3. Either:
   1. Solve the merge conflict with your favorite editor and finish the merge (`git status` will tell you what to do), **or**
   2. Use `git mergetool --tool=emerge` (for emacs fans) or `git mergetool --tool=vimdiff` (for vim fans) and finish the merge (`git status` will tell you what to do)

## Relevant commands
- `git branch`
- `git merge`
- `git status`
- `git mergetool --tool=emerge`
- `git mergetool --tool=vimdiff`
- `git add`
- `git commit`

## Panels Overview
**Left Panel (LOCAL)**: Represents the changes from the current branch (e.g., main).  
Shows the code as it exists in your branch before the merge.  
**Middle Panel (BASE):** Represents the common ancestor of the two branches being merged.  
Shows the original state of the code before any changes were made in either branch.  
**Right Panel (REMOTE):** Represents the changes from the branch being merged in (e.g., Mergesort-Impl).  
Shows the code as it exists in the branch you're trying to merge.  

## Conflict Markers
**<<<<<<< HEAD**: Marks the beginning of the conflicting changes from your current branch.  
**=======**: Separates your changes from the incoming changes.  
**>>>>>>> Mergesort-Impl**: Marks the end of the conflicting changes from the branch being merged.  

## Resolving the Conflict
To resolve the conflict, you need to decide which changes to keep or how to combine them.  
You can:  
* Keep the changes from your branch: Remove the conflict markers and the code from the REMOTE section.
* Keep the changes from the incoming branch: Remove the conflict markers and the code from the LOCAL section.
* Combine changes: Manually edit the code to incorporate changes from both sections, then remove the conflict markers.

### [<<Previous](6-3-way-merge.md) &nbsp;&nbsp; [>>Next](8-branch-rebase.md)