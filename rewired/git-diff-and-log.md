* ~the perspective to consider should always be from the right side~: **No: its just a comparaison between A and B**: look at the output: either the commit is at position A (marked with ---) or at position B (marked with +++)
  * `git diff A..B`: we are checking the changes between the two points (commits): we are comparing the two of them.  
    just look at the output carefully **using the markers --- and +++**
  * `git diff A..B --name-only`: will list the filenames only
  * `git diff A..B -- somefile.txt`: see diff for a specific file
  * At the end: `git diff A..B` or `git diff B..A` doesnt really make a difference !
  * What really differs when you change the order of the points being compared is when you use **...**
    * with ... the comparaison is against the common ancestor of the two branches before they diverge  
      then in this case it will show exlusively what's in the right side branch that is not in the left side branch  
      e.g.: `git diff HEAD...origin/main`  will show changes in the upstream branch main that are not present locally.
 * **git log** seems to have the opposite behavior !!
   * it shows all differences between two points irrespective of the order when you use ...
   * it shows history that is present in A but not in B when you use .. as in  `git log B..A`
     
    
  
