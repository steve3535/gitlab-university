# Docker Crash Course for GitLab CI/CD

2. Verify installation:
```bash
docker --version
docker-compose --version
```

## Core Docker Concepts

### What is Docker?
Docker is a platform that uses containerization to package applications and their dependencies. Think of containers as lightweight, portable, and isolated boxes that contain everything needed to run an application.

Key concepts:
- **Container**: A running instance of an image
- **Image**: A template containing application code, runtime, libraries, and dependencies
- **Dockerfile**: A script to build images
- **Registry**: A repository for storing and sharing images
- **Docker Compose**: A tool for defining multi-container applications

## Hands-on Exercises

### Exercise 1: Your First Container

1. Run your first container:
```bash
docker run hello-world
```

2. List running containers:
```bash
docker ps
```

3. List all containers (including stopped ones):
```bash
docker ps -a
```

**🔨 Try it yourself:**
1. Run an Ubuntu container interactively:
```bash
docker run -it ubuntu bash
```
2. Inside the container, try some commands:
```bash
ls
pwd
cat /etc/os-release
exit
```

### Exercise 2: Working with Images

1. List local images:
```bash
docker images
```

2. Pull an image:
```bash
docker pull nginx
```

3. Run nginx container:
```bash
docker run -d -p 8080:80 nginx
```

4. Visit http://localhost:8080 in your browser

**🔨 Try it yourself:**
1. Pull and run different versions of Node.js:
```bash
docker run -it node:14 node -v
docker run -it node:16 node -v
docker run -it node:18 node -v
```

### Exercise 3: Writing Dockerfiles

Create a simple Node.js application:

1. Create a new directory:
```bash
mkdir docker-demo
cd docker-demo
```

2. Create `app.js`:
```javascript
console.log("Hello from Docker!");
```

3. Create `Dockerfile`:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY app.js .
CMD ["node", "app.js"]
```

4. Build and run:
```bash
docker build -t my-node-app .
docker run my-node-app
```

**🔨 Try it yourself:**
Create a Python web application:

1. Create `app.py`:
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, Docker!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

2. Create `requirements.txt`:
```
flask==2.0.1
```

3. Create `Dockerfile`:
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
```

4. Build and run:
```bash
docker build -t my-flask-app .
docker run -p 5000:5000 my-flask-app
```

### Exercise 4: Multi-stage Builds

Create a Go application with multi-stage build:

1. Create `main.go`:
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello from a multi-stage build!")
}
```

2. Create `Dockerfile`:
```dockerfile
# Build stage
FROM golang:1.19 AS builder
WORKDIR /app
COPY main.go .
RUN CGO_ENABLED=0 go build -o app

# Final stage
FROM alpine:3.14
WORKDIR /app
COPY --from=builder /app/app .
CMD ["./app"]
```

3. Build and run:
```bash
docker build -t my-go-app .
docker run my-go-app
```

**🔨 Try it yourself:**
Create a multi-stage build for a React application:

1. Create React app:
```bash
npx create-react-app docker-react
cd docker-react
```

2. Create `Dockerfile`:
```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
```

3. Build and run:
```bash
docker build -t my-react-app .
docker run -p 8080:80 my-react-app
```

### Exercise 5: Docker Compose

Create a multi-container application with Node.js and MongoDB:

1. Create project structure:
```bash
mkdir compose-demo
cd compose-demo
```

2. Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - MONGODB_URI=mongodb://db:27017/myapp
    depends_on:
      - db
  db:
    image: mongo:4.4
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
```

3. Create Node.js application files and run:
```bash
docker-compose up --build
```

**🔨 Try it yourself:**
Create a WordPress development environment:

1. Create `docker-compose.yml`:
```yaml
version: '3.8'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      - WORDPRESS_DB_HOST=db
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=secret
      - WORDPRESS_DB_NAME=wordpress
    depends_on:
      - db
  db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=somewordpress
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=secret
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

2. Run the environment:
```bash
docker-compose up -d
```

### Exercise 6: CI/CD Ready Practices

Best practices for Docker in GitLab CI/CD:

1. Create efficient builds:
```dockerfile
# Bad practice
FROM node:18
COPY . .
RUN npm install
CMD ["npm", "start"]

# Good practice
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

2. Use .dockerignore:
```
node_modules
.git
.env
*.log
```

3. Tag images properly:
```bash
docker build -t myapp:${CI_COMMIT_SHA} .
```

**🔨 Try it yourself:**
Create a complete CI/CD ready application:

1. Create a simple Express.js application
2. Add proper Docker configuration
3. Create `.gitlab-ci.yml`:
```yaml
image: docker:20.10.16

services:
  - docker:20.10.16-dind

variables:
  DOCKER_TLS_CERTDIR: "/certs"

stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - docker save myapp:$CI_COMMIT_SHA > image.tar
  artifacts:
    paths:
      - image.tar

test:
  stage: test
  script:
    - docker load < image.tar
    - docker run myapp:$CI_COMMIT_SHA npm test

deploy:
  stage: deploy
  script:
    - docker load < image.tar
    - docker tag myapp:$CI_COMMIT_SHA registry.example.com/myapp:latest
    - docker push registry.example.com/myapp:latest
```

## Common Docker Commands Reference

```bash
# Container Management
docker run         # Create and start a container
docker start       # Start stopped container
docker stop        # Stop running container
docker restart     # Restart container
docker rm          # Remove container
docker logs        # View container logs
docker exec        # Execute command in container

# Image Management
docker build      # Build image from Dockerfile
docker pull       # Pull image from registry
docker push       # Push image to registry
docker rmi        # Remove image
docker tag        # Tag image

# System
docker system df  # Show docker disk usage
docker system prune # Remove unused data

# Compose
docker-compose up    # Create and start containers
docker-compose down  # Stop and remove containers
docker-compose logs  # View output from containers
```

## Troubleshooting Tips

1. Container won't start:
```bash
docker logs <container-id>
```

2. Permission denied:
```bash
sudo usermod -aG docker $USER
```

3. Port already in use:
```bash
docker ps
# Find and stop container using the port
```

4. Clean up system:
```bash
docker system prune -a
```

## Best Practices for GitLab CI/CD

1. Use specific image tags instead of `latest`
2. Implement proper caching strategies
3. Use multi-stage builds to reduce image size
4. Always specify EXPOSE and WORKDIR in Dockerfiles
5. Use .dockerignore to exclude unnecessary files
6. Set appropriate environment variables
7. Use health checks for production containers
8. Implement proper logging
9. Use Docker layer caching effectively
10. Regularly update base images for security

