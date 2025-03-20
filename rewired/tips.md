* u wanna see whats gonna be committed ? (like a commit preview): `git commit`
* u wanna check the ignored files being taken into account ? `git status --ignored`
* u are not in a specific repo but still want to check something overthere without changing directory ? `git -C /path/to/another/repo status`
* How to ignore .gitignore ? i.e have a local .gitignore and keep unchanged the shared one from upstream
  * Option 1: use the file *.git/info/exclude*
  * Option 2: put exceptions for tracking: `git --no-index --assume-no-changes /path/to/file` 
  
