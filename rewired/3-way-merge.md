* Git can be quite smart
* in a merge situation: check if conflict will arise with:
  ```bash
  git merge --no-commit --no-ff origin/main
  git merge --abort
  # OR if you agree - for e.g. if simulated merge went well:
  # git commit
  ```
  
