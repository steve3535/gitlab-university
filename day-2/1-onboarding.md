# Prereqs

## 1. Project Creation
1. Log into GitLab
2. Click "New Project"
3. Select "Create blank project"
4. Fill in project details:
   - Project name: `simple-webapp-[your-gitlab-username]`
   - "Visibility Level: Set to 'Private' to protect your code from being publicly accessible while you're learning."  
   - Initialize with a README: Yes
     A README file gives your project an initial structure and lets others understand its purpose.  

## Your virtual Desk: spin up a github codespace
1. Fork the gitlab-university repository - https://github.com/steve3535/gitlab-university -
   * Go to your Github account
   * In the to right search bar, search for the repository *steve3535/gitlab-university*
   * Select fork
   * Leave all defaults and click "Create Fork"
2. Create a codespace
   * In your copy of the repository (the fork you just created), click Code
   * Select Codespaces tab, and click "Create Codespace"  
   It will open up automatically a vscode web space for you <br />

   ![sample](sample-codespace.png)   

3. Connect your codespace to your gitlab project
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
 
# Technical Blueprint - Personal Dev Portfolio

## Project Structure

```
personal-dev-portfolio/
├── public/
│   ├── index.html
│   ├── styles/
│   │   └── main.css
│   └── assets/
│       └── images/
├── src/
│   └── api/
│       └── server.js
├── tests/
│   ├── app.test.js
│   └── api.test.js
├── .gitlab-ci.yml
├── .gitignore
├── package.json
└── README.md
```

## Technology Stack

### Frontend
- HTML5
- CSS3
- Vanilla JavaScript (keeping it simple)

### Backend
- Node.js with Express
- Simple JSON file for data storage

### Testing
- Jest for unit testing
- SuperTest for API testing

### CI/CD
- GitLab CI/CD pipelines
- Node.js docker image
- GitLab Pages for deployment

## Development Steps

1. **Basic Structure Setup**
   - Create directory structure
   - Initialize Node.js project
   - Setup basic Express server

2. **Frontend Development**
   - Create responsive layout
   - Implement portfolio sections
   - Add simple animations

3. **Backend API**
   - Create REST endpoints
   - Implement data handling
   - Add error handling

4. **Testing**
   - Write unit tests
   - Implement API tests
   - Add coverage reporting

5. **CI/CD Pipeline**
   - Configure .gitlab-ci.yml
   - Set up stages:
     - Build
     - Test
     - Security Scan
     - Deploy

## Key Features

1. **Portfolio Section**
   - About Me
   - Skills
   - Projects
   - Contact Form

2. **API Endpoints**
   - GET /api/profile
   - GET /api/skills
   - GET /api/projects
   - POST /api/contact

3. **Analytics Integration**
   - Page view tracking
   - User interaction metrics
   - Performance monitoring

## Security Considerations

1. **Frontend**
   - Content Security Policy
   - XSS prevention
   - Input validation

2. **Backend**
   - Rate limiting
   - Input sanitization
   - CORS configuration

3. **CI/CD**
   - Dependency scanning
   - SAST (Static Application Security Testing)
   - Container scanning
