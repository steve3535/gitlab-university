## 1. Create Basic Structure

First, create the following directory structure:

```bash
mkdir -p public/styles public/assets/images src/api tests
touch public/index.html public/styles/main.css src/api/server.js
touch tests/app.test.js tests/api.test.js .gitignore
```
```bash
# check the structure
tree
```

## 3. Setup Node.js Project

Initialize Node.js project and install dependencies:

```bash
npm init -y
npm install express cors helmet
npm install --save-dev jest supertest nodemon
```

## 4. Configure Base Files

### a. package.json
Update your package.json to include:

```json
{
  "name": "personal-dev-portfolio",
  "version": "1.0.0",
  "description": "Personal Developer Portfolio with Analytics",
  "main": "src/api/server.js",
  "scripts": {
    "start": "node src/api/server.js",
    "dev": "nodemon src/api/server.js",
    "test": "jest --coverage"
  }
}
```

### b. .gitignore
Add essential ignore patterns:

```
node_modules/
coverage/
.env
*.log
.DS_Store
```

### c. public/index.html
Basic HTML structure:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Developer Portfolio</title>
    <link rel="stylesheet" href="styles/main.css">
</head>
<body>
    <header>
        <h1>Your Name</h1>
        <nav>
            <ul>
                <li><a href="#about">About</a></li>
                <li><a href="#skills">Skills</a></li>
                <li><a href="#projects">Projects</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
        </nav>
    </header>
    
    <main>
        <section id="about">
            <h2>About Me</h2>
            <p>Your professional introduction goes here.</p>
        </section>
        
        <section id="skills">
            <h2>Skills</h2>
            <div id="skills-container">
                <!-- Skills will be loaded via API -->
            </div>
        </section>
        
        <section id="projects">
            <h2>Projects</h2>
            <div id="projects-container">
                <!-- Projects will be loaded via API -->
            </div>
        </section>
        
        <section id="contact">
            <h2>Contact</h2>
            <form id="contact-form">
                <input type="email" placeholder="Your Email" required>
                <textarea placeholder="Your Message" required></textarea>
                <button type="submit">Send</button>
            </form>
        </section>
    </main>
    
    <footer>
        <p>© 2024 Your Name. Built with GitLab.</p>
    </footer>
</body>
</html>
```

### d. public/styles/main.css
Basic styling:

```css
/* Reset and base styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    line-height: 1.6;
    color: #333;
}

/* Header styles */
header {
    background: #2D2D2D;
    color: white;
    padding: 1rem;
    position: fixed;
    width: 100%;
    top: 0;
}

nav ul {
    list-style: none;
    display: flex;
    justify-content: flex-end;
}

nav ul li {
    margin-left: 2rem;
}

nav a {
    color: white;
    text-decoration: none;
}

/* Main content */
main {
    margin-top: 80px;
    padding: 2rem;
}

section {
    margin-bottom: 3rem;
    padding: 2rem;
    border-radius: 8px;
    background: #f9f9f9;
}

/* Form styles */
form {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    max-width: 500px;
}

input, textarea {
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
}

button {
    padding: 0.5rem 1rem;
    background: #2D2D2D;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

/* Footer */
footer {
    text-align: center;
    padding: 2rem;
    background: #2D2D2D;
    color: white;
}
```

### e. src/api/server.js
Basic Express server setup:

```javascript
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const path = require('path');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Sample data
const skills = [
    { id: 1, name: 'JavaScript', level: 'Advanced' },
    { id: 2, name: 'Node.js', level: 'Intermediate' },
    { id: 3, name: 'GitLab CI/CD', level: 'Intermediate' }
];

const projects = [
    {
        id: 1,
        name: 'Portfolio Website',
        description: 'Personal portfolio with GitLab CI/CD',
        technologies: ['Node.js', 'Express', 'GitLab CI']
    }
];

// API Routes
app.get('/api/skills', (req, res) => {
    res.json(skills);
});

app.get('/api/projects', (req, res) => {
    res.json(projects);
});

app.post('/api/contact', (req, res) => {
    const { email, message } = req.body;
    // In a real app, you would handle the contact form submission here
    res.json({ success: true, message: 'Message received' });
});

// Error handling
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

module.exports = app; // For testing
```

### f. tests/api.test.js
Basic API tests:

```javascript
const request = require('supertest');
const app = require('../src/api/server');

describe('API Endpoints', () => {
    test('GET /api/skills should return skills array', async () => {
        const res = await request(app).get('/api/skills');
        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBeTruthy();
    });

    test('GET /api/projects should return projects array', async () => {
        const res = await request(app).get('/api/projects');
        expect(res.statusCode).toBe(200);
        expect(Array.isArray(res.body)).toBeTruthy();
    });
});
```

## 5. Initial Commit

Commit your changes:

```bash
git add .
git commit -m "Initial project setup with basic structure"
git push origin main
```

## Next Steps

After completing this setup:
1. Test the application locally:
   ```bash
   npm install
   npm run dev
   ```
2. Visit `http://localhost:3000` to see your portfolio
3. Run tests:
   ```bash
   npm test
   ```
4. Create merge request for the initial setup
5. Proceed to CI/CD pipeline configuration
