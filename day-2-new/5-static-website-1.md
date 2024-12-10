### Prerequisites
Before starting this tutorial, ensure you have the following installed on your machine:

- Node.js (Check with `node --version`)
- npm (Check with `npm --version`) 
- Git
- A GitLab.com account

### Part 1: Setting Up Your Development Environment

1. First, let's verify our development environment. Open a terminal and run:
   ```bash
   node --version
   npm --version
   ```
   If either command fails, you'll need to install Node.js and npm first.

2. Install the Gatsby CLI tool globally:
   ```bash
   npm install -g gatsby-cli
   ```
   
   🚨 Common Issues:
   - If you get a permission error on Unix-like systems, you may need to use `sudo`
Great! Let me continue with the next section about creating the static website:

### Part 2: Creating Your Static Website

1. Create a new Gatsby website using the default starter:
   ```bash
   gatsby new static-website
   cd static-website
   ```
   
2. Start the development server to verify your site works:
   ```bash
   gatsby develop
   ```
   
   This will start a development server at `http://localhost:8000`. Open your browser and navigate to this address.

   ✨ Success Check:
   - You should see the default Gatsby starter page
   - The page should have a header, some text, and links
   
   🚨 Common Issues:
   - If port 8000 is already in use, Gatsby will suggest an alternative port

### Part 3: Setting up Your GitLab Repository

1. Log into GitLab.com and create a new project:
   - Click "New project"
   - Name it "my-static-website"

2. Connect your local repository to GitLab:


Would you like me to continue with the next section that introduces CI/CD concepts and shows how to implement them in this project?
