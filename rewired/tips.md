* u wanna see whats gonna be committed ? (like a commit preview): `git commit`
* u wanna check the ignored files being taken into account ? `git status --ignored`
* u are not in a specific repo but still want to check something overthere without changing directory ? `git -C /path/to/another/repo status`
* How to ignore .gitignore ? i.e have a local .gitignore and keep unchanged the shared one from upstream
  * Option 1: use the file *.git/info/exclude*
  * Option 2: put exceptions for tracking: `git update-index --assume-unchanged /path/to/file`
  * Option 3: skip the worktree for a specific file: `git update-index --skip-worktree /path/to/file`  
  >Let me clatify things:
  >Nothing is simple in git, even ignoring files.
  
  **.gitignore** is the classic solution
  there are even generators for it (not only in IDEs but remember also this site => gitigniore.io -- from my old friend of toptal)  
  the issue with .gitignore is that is ahred with the team, so its part of the commits and needs to be shipped upstream  
  what happens if you want to ignore some very specific local files but that are only peculliar to you ... very easy situation to happen, ha !

  **.git/info/exclude**
  >it can help skip tracking things without using .gitignore, so apparently solving the above issue.
  but thereis a trap ...
  > remember in git the distinction between tracked and changed: u can have something tracked but that is changing or not: track is the very first step to put something unde rthe control of git

  And here is the issue with the exclude file: it will only skip files that are untracked.  
  lesson of this is that u should create this file ahead of your files, for it to work !  

  **git update-index --assume-unchanged /path/to/file**
  > lets say u already have a 'dirty' git environment but u still want to catchup :)
  > this one will ignore the file but not like the way you think of !!!
  > here its like a stating there is a file that constantly doesnt change: its empirical ! meaning the only benefit here is to let git be more performant by avoiding tracking unecesary files.  
  > because u have to imagine that when we ask git to track, it will be checking every time whats happening with the file - like u when u wait for a parcel from dhl  

  A good way of illustrating this is whith: `git ls-files -v`  
  **H** is high priority tracking  
  **h** is low priority tracking  
  **S** is for skipping  

  **git update-index --skip-worktree /path/to/file**  
  > what we really want is this.
  > this will really skips all the changes locally in your WD while the file actually changes.
* jai remarké qqchz detrange avec codepsaces. impossible den lancer ou den ouvrir en fenetre incognito sous un autre compte. (firefox)
  finalement, le workflow: commencer par ouvrir le codespace avec letudiant beta dans la fenetre incognito avant de se connecter en tant que steve3535 dans la fenetre main
  



  
  
    
  
  
  
  
