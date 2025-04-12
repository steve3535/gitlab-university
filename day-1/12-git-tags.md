# Git Tags

Tags are references that point to specific points in Git history. Tags are commonly used to mark release points (v1.0, v2.0 and so on). Think of them as branch references that don't change - after you create a tag for a specific commit, the tag will always point to that commit.

## Setup:

1. Run `source setup_tagging.sh`

## The task

1. Check the log to see the commit history
2. Create a tag called `v1.0` that points to the first commit
   - Use `git tag v1.0 <commit-sha>`
3. Create an annotated tag called `v1.1` pointing to the latest commit
   - Use `git tag -a v1.1 -m "Release version 1.1"`
4. List all tags
   - Use `git tag`
5. View the details of tag `v1.1`
   - Use `git show v1.1`
6. Delete tag `v1.0`
   - Use `git tag -d v1.0`
7. Create a new annotated tag `v2.0` pointing to the current commit
   - Add a message describing the changes
8. Push a single tag
   - Use `git push origin v2.0`
9. Push all tags
   - Use `git push origin --tags`
10. Delete a remote tag
    - Use `git push origin --delete v2.0`

## Useful commands

- `git tag` - list all tags
- `git tag <tag-name>` - create a lightweight tag
- `git tag -a <tag-name> -m "message"` - create an annotated tag
- `git tag -d <tag-name>` - delete a tag
- `git show <tag-name>` - show tag details
- `git push origin <tag-name>` - push a specific tag
- `git push origin --tags` - push all tags
- `git push origin --delete <tag-name>` - delete a remote tag

## Types of Tags

1. **Lightweight Tags**
   - Simply a pointer to a specific commit
   - Created with `git tag <tag-name>`
   - Contains no additional information

2. **Annotated Tags**
   - Stored as full objects in the Git database
   - Include tagger name, email, date, and message
   - Created with `git tag -a <tag-name> -m "message"`
   - Recommended for releases

## Best Practices

1. Use annotated tags for releases
2. Use semantic versioning (MAJOR.MINOR.PATCH)
3. Tag release commits immediately after they're created
4. Use consistent tag naming conventions
5. Include relevant release notes in annotated tag messages

### [<<Previous](11-basic-stashing.md) &nbsp;&nbsp; [>>Next](13-remote.md)
