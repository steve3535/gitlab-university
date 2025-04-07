* u wanna see whats gonna be committed ? (like a commit preview): `git commit`
* u wanna check the ignored files being taken into account ? `git status --ignored`
* u are not in a specific repo but still want to check something overthere without changing directory ? `git -C /path/to/another/repo status`
* How to ignore .gitignore ? i.e have a local .gitignore and keep unchanged the shared one from upstream
  * Option 1: use the file *.git/info/exclude*
  * Option 2: put exceptions for tracking: `git update-index --assume-unchanged /path/to/file`
  * Option 3: skip the worktree for a specific file: `git update-index --skip-worktree /path/to/file`
  Let me clatify things:
  Nothing is simple in git, even ignoring files.
  **.gitignore** is the classic solution, an there a re even templates for it (not only in IDEs but remember also this site => gitigniore.io -- from my old friend of toptal)  
    the issue with .gitignore is that is ahred with the team, so its part of the commits and needs to be shipped upstream  
    what happens if you want to ignore some very specific local files but that are only peculliar to you ... very easy situation to happen, ha !
  
  
