# TaskTrack Manual SDLC Exercise: Instructor Setup Plan

## Overview
This document outlines the step-by-step plan for instructors to set up the "TaskTrack" exercise, which demonstrates the manual software development lifecycle (SDLC) before introducing GitLab CI/CD as a solution. The exercise involves four teams working through the traditional build, test, secure, and deploy steps with intentional pain points.

## Phase 1: Preparation Materials

### 1.1 Repository Setup
1. Create a starter repository with the following structure:
   ```
   tasktrack/
   ├── frontend/
   │   ├── index.html          # Basic HTML skeleton
   │   ├── styles.css          # Simple styling
   │   └── script.js           # Frontend logic with API calls
   ├── backend/
   │   ├── src/
   │   │   └── main/
   │   │       ├── java/
   │   │       │   └── com/
   │   │       │       └── tasktrack/
   │   │       │           ├── controllers/
   │   │       │           │   └── TaskController.java     # REST endpoints (incomplete)
   │   │       │           ├── models/
   │   │       │           │   └── Task.java               # Data model
   │   │       │           ├── services/
   │   │       │           │   └── TaskService.java        # Business logic
   │   │       │           └── Application.java            # Main application class
   │   │       └── resources/
   │   │           └── application.properties              # Configuration
   │   └── pom.xml            # Maven dependencies (include outdated dependencies)
   ├── documentation/
   │   ├── handover_templates/
   │   │   ├── dev_to_qa.md               # Template for Dev→QA handover
   │   │   ├── qa_to_security.md          # Template for QA→Security handover
   │   │   └── security_to_ops.md         # Template for Security→Ops handover
   │   └── instructions/
   │       ├── dev_instructions.md        # Instructions for Dev team
   │       ├── qa_instructions.md         # Instructions for QA team
   │       ├── security_instructions.md   # Instructions for Security team
   │       └── ops_instructions.md        # Instructions for Ops team
   └── README.md                          # Project overview
   ```

### 1.2 Create Intentional Issues
1. Add the following intentional issues to the code:
   - **Compile-time error**: Missing semicolon in one Java file
   - **Runtime bug**: NullPointerException when deleting a non-existent task
   - **Security issue**: Unsanitized input in the controller
   - **Performance issue**: Inefficient algorithm in the task filtering logic
   - **Dependency issue**: Include an outdated library with a known vulnerability (e.g., old log4j)
   - **License issue**: Include a GPL-licensed dependency in pom.xml

### 1.3 Prepare Team Instructions
1. Develop detailed instructions for each team (already included in the repo structure above)
2. Create handover templates with specific fields to complete (already included in the repo structure)
3. Prepare evaluation criteria for each team's work

## Phase 2: Environment Setup

### 2.1 Development Environment
1. Ensure all required software is installed in the lab:
   - JDK 11+
   - Maven 3.6+
   - Git
   - Text editors or IDEs
   - Web browsers

### 2.2 Test/Pre-Prod/Prod Environment Templates
1. Create environment directory templates:
   ```
   environments/
   ├── test/
   │   └── config/
   │       └── application.properties      # Test-specific configuration
   ├── preprod/
   │   └── config/
   │       └── application.properties      # Pre-prod configuration
   └── prod/
   │   └── config/
   │       └── application.properties      # Production configuration
   ```

2. Configure slight differences between environments:
   - Different server ports
   - Different logging levels
   - Different feature flags

## Phase 3: Exercise Materials

### 3.1 Team Worksheets
1. Create worksheets for each team to record their activities:
   - Dev Team: Build log, error tracking, static analysis results
   - QA Team: Test cases, bug reports, test results
   - Security Team: Vulnerability findings, license issues, security recommendations
   - Ops Team: Deployment checklist, environment configurations, release notes

### 3.2 Communication Protocols
1. Develop communication procedures:
   - How teams should notify each other when their phase is complete
   - How to document and track issues between teams
   - Required information for handovers

## Phase 4: Classroom Setup

### 4.1 Physical/Virtual Space Arrangement
1. Designate areas for each team (if in-person)
2. Set up communication channels (if remote):
   - Team-specific chat channels
   - Document sharing platforms
   - Video conferencing links

### 4.2 Timer and Notification System
1. Prepare a timing system to keep teams on schedule
2. Create notifications for phase transitions

## Phase 5: Exercise Documentation

### 5.1 Student Handouts
1. Create introduction document explaining:
   - The purpose of the exercise
   - The TaskTrack application concept
   - Team roles and responsibilities
   - Timeline and deliverables

### 5.2 Reflection Questions
1. Develop post-exercise reflection questions:
   - What pain points did you experience?
   - How much time was spent waiting for other teams?
   - What issues were most difficult to communicate?
   - How could the process be improved?

## Detailed Exercise Timeline

### Introduction (15 minutes)
1. Present the concept of the exercise
2. Explain the TaskTrack application
3. Form teams and assign roles
4. Distribute team-specific instructions

### Development Phase (20 minutes)
1. Team Dev:
   - Review and complete the code
   - Fix the compile-time error
   - Build the application using Maven
   - Run static code analysis manually
   - Complete the dev_to_qa.md handover document
   - Notify QA team when complete

### QA Phase (15 minutes)
1. Team QA:
   - Receive the built application from Dev
   - Execute manual tests according to test plan
   - Document bugs found (including the intentional NullPointerException)
   - Send bug reports back to Dev
   - After Dev fixes, verify the fixes
   - Complete qa_to_security.md handover document
   - Notify Security team when complete

### Security Phase (15 minutes)
1. Team Security:
   - Receive the verified application from QA
   - Perform manual code review for security issues
   - Check dependencies for vulnerabilities
   - Verify license compliance
   - Document findings
   - Send security issues back to Dev
   - After Dev fixes, verify the fixes
   - Complete security_to_ops.md handover document
   - Notify Ops team when complete

### Operations Phase (15 minutes)
1. Team Ops:
   - Receive the secured application from Security
   - Set up test, pre-prod, and prod environments
   - Package the application (create JAR file)
   - Deploy to test environment
   - Verify deployment
   - Deploy to pre-prod environment
   - Verify deployment
   - Deploy to production environment
   - Verify deployment
   - Document deployment process and issues

### Reflection Discussion (10 minutes)
1. Gather all teams
2. Discuss pain points experienced
3. Identify most time-consuming activities
4. Collect ideas for process improvement

## Phase 6: Follow-Up Materials

### 6.1 Solution Code
1. Prepare a "correct" version of the TaskTrack application
2. Include proper documentation and comments

### 6.2 GitLab CI/CD Preview
1. Prepare a GitLab CI/CD pipeline configuration that automates all the manual steps
2. Create a comparison document showing manual vs. automated processes

### 6.3 Assessment Materials
1. Develop assessment criteria for team performance
2. Create feedback forms for student experience

## Appendix: Required Resources

### A. Software Requirements
- JDK 11+ (OpenJDK or Oracle JDK)
- Maven 3.6+
- Git
- Text editors (VS Code, IntelliJ, etc.)
- Web browsers

### B. Hardware Requirements
- One computer per student (or pair)
- Projector/screen for instructions
- Whiteboard/digital board for tracking progress

### C. Time Requirements
- Total exercise time: 90 minutes
- Setup time: 30 minutes before class
- Cleanup time: 15 minutes after class

### D. Materials
- Printed team instructions (optional)
- Team identification (name tags, signs)
- Timing device visible to all teams
