## 1. Project Creation
### Step 1: Create the Project

Now that we have our group set up, let's create our main project:

1. From your group page, click the "New project" button
2. Select "Create blank project"
3. Configure the project:
   - Project name: `taskmaster`
   - Project URL: Will auto-populate based on name
   - Initialize repository with a README: Yes
4. Click "Create project"

**PS**: Choose "Users", not "Group" as part of the project URL.  

![create_project](create_project.png)

## 2. Your virtual Desk: spin up a github codespace
1. **Fork the gitlab-university repository** - https://github.com/steve3535/gitlab-university -
   * Go to your Github account
   * In the to right search bar, search for the repository *steve3535/gitlab-university*
   * Select fork
   * Leave all defaults and click "Create Fork"
2. **Create a codespace**
   * In your copy of the repository (the fork you just created), click Code
   * Select Codespaces tab, and click "Create Codespace"  
   It will open up automatically a vscode web space for you <br />

   ![sample](sample-codespace.png)   

3. **Connect your codespace to your gitlab project**  
   3.1. Go to your project in gitlab and generate a Personal Access Token:
     * Settings > Access Tokens > Add new token
     * Select "Maintainer" role and the following scopes: read repository, write repository, read registry, write registry
     * Click "Create Project Access Token"
     * Copy down the token  
   
   3.2. Back to your codespace,clone your gitlab project
     ```bash
     @kwakoulux ➜ /workspaces/gitlab-university (main) $ cd ..
     kwakoulux ➜ /workspaces $ git clone https://oauth2:glp...xxxxxxx-@gitlab.com/kwakoulux/simple-webapp-kwakoulux
     Cloning into 'simple-webapp-kwakoulux'...
     warning: redirecting to https://gitlab.com/kwakoulux/simple-webapp-kwakoulux.git/
     remote: Enumerating objects: 3, done.
     Receiving objects: 100% (3/3), done.
     @kwakoulux ➜ /workspaces $
     ```   
   You can now open the project in your codespace.  
 
