# GitLab Project Planning Tutorial: Building TaskMaster

Welcome to this hands-on tutorial where you'll learn GitLab's project planning and organization features by building TaskMaster, a personal task management web application. This tutorial focuses on proper project setup and planning using GitLab's powerful tools.

## Tutorial Overview
In this tutorial, you'll learn how to:
1. Set up project structure in GitLab
2. Use GitLab's planning tools to organize work
3. Break down features into manageable tasks
4. Track progress effectively
5. Collaborate using GitLab's features

## Part 1: Initial Setup & Project Structure

### Step 1: Create a Group
First, we'll create a group to organize our project:

1. Log into GitLab.com
2. Click the "+" button at the top of the left sidebar
3. Select "New group"
4. For the group setup:
   - Name: `taskmaster apps`
   - Visibility level: Public
   - Group URL: Will auto-populate based on the name
5. Click "Create group"

A group provides a dedicated space for our TaskMaster application and potential future related projects. You can think of it as a container that can hold multiple related projects, making it easier to manage access control and organize work at a higher level.

---

> **💡 Tip**: While you could create the project directly without a group, using a group structure provides better organization and scalability. It allows you to add more related projects later and manage permissions at a group level.

### Step 2: Create the Project

Now that we have our group set up, let's create our main project:

1. From your group page, click the "New project" button
2. Select "Create blank project"
3. Configure the project:
   - Project name: `taskmaster`
   - Project URL: Will auto-populate based on name
   - Visibility level: Public 
   - Initialize repository with a README: Yes
4. Click "Create project"

### Step 3: Project Organization

Before diving into features, let's set up our project's basic organization:

1. Create a project Wiki for documentation:
   - Go to your project sidebar
   - Select **Wiki** under **Plan**
   - Click "Create the first page"
   - Title: "TaskMaster Documentation"
   - Content: Add a basic introduction and project overview
   ```markdown
   # TaskMaster Documentation
   
   TaskMaster is a personal task management web application that helps users organize and track their daily tasks.
   
   ## Features
   - Create and manage tasks
   - Organize tasks into categories
   - Set task priorities
   - Track task completion
   - Simple and intuitive interface
   
   ## Project Structure
   This section will be updated as we build the project.
   ```
   - Click "Create page"

2. Set up basic labels:
   - Go to **Manage** > **Labels**
   - Click "Generate a default set of labels"
   - Add custom labels:
     - `priority::high` (Red)
     - `priority::medium` (Yellow)
     - `priority::low` (Green)
     - `type::feature` (Blue)
     - `type::bug` (Red)
     - `type::documentation` (Green)
     - `status::planning` (Yellow)
     - `status::in-progress` (Blue)
     - `status::review` (Purple)
     - `status::done` (Green)

> **💡 Tip**: Notice how we use double colons (::) in some label names. These are called "scoped labels" and ensure that an issue can only have one label from each scope (e.g., only one priority level).

Now we have a basic project structure with:
- A central location for code (repository)
- Documentation space (wiki)
- Organized labeling system for tracking work

## Part 2: Breaking Down Features

### Step 4: Create Milestones

Let's organize our work into milestones to track progress effectively:

1. Go to **Plan** > **Milestones**
2. Click "New milestone"
3. Create the following milestones:

#### MVP (Minimum Viable Product)
- Title: `MVP Release`
- Description: 
```markdown
Initial release of TaskMaster with core functionality:
- Basic task creation and management
- Task list view
- Task completion tracking
```
- Start date: Today
- Due date: Today + 2 weeks

#### Future Enhancements
- Title: `Enhanced Features`
- Description:
```markdown
Additional features to improve user experience:
- Task categories
- Priority management
- Due dates
```
- Start date: After MVP
- Due date: 2 weeks after MVP

### Step 5: Create Issues for Features

Now let's break down our MVP milestone into specific issues. We'll create several issues to track different features:

1. Go to **Plan** > **Issues**
2. Click "New issue"
3. Create the following issues:

#### Core Task Management
```markdown
Title: Implement basic task management
Description:
## User Story
As a user, I want to create, view, and manage my tasks so that I can keep track of my to-do items.

## Requirements
- Create new tasks with a title and description
- View list of all tasks
- Mark tasks as complete
- Delete tasks

## Acceptance Criteria
- [ ] User can create a new task
- [ ] User can see all their tasks in a list
- [ ] User can mark tasks as complete
- [ ] User can delete unwanted tasks
- [ ] UI is simple and intuitive
```
- Labels: `type::feature`, `priority::high`, `status::planning`
- Milestone: MVP Release
- Weight: 8

#### Task List Interface
```markdown
Title: Create task list interface
Description:
## User Story
As a user, I want a clean and organized interface to view my tasks so that I can easily understand my workload.

## Requirements
- Display tasks in a clear list format
- Show task completion status
- Simple and responsive design

## Acceptance Criteria
- [ ] Tasks are displayed in a clean, organized list
- [ ] Each task shows its completion status
- [ ] Interface works well on both desktop and mobile
- [ ] Visual feedback for task completion
```
- Labels: `type::feature`, `priority::high`, `status::planning`
- Milestone: MVP Release
- Weight: 5

#### Basic Documentation
```markdown
Title: Create user documentation
Description:
## Task Description
Create basic documentation for TaskMaster users including:
- Getting started guide
- How to create tasks
- How to manage tasks
- Basic troubleshooting

## Requirements
- Clear, concise writing
- Screenshots of main features
- Step-by-step instructions

## Deliverables
- [ ] Getting Started guide
- [ ] Feature documentation
- [ ] Basic troubleshooting guide
```
- Labels: `type::documentation`, `priority::medium`, `status::planning`
- Milestone: MVP Release
- Weight: 3

