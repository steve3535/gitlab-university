# GitLab Project Planning Tutorial: Building TaskMaster

Welcome to this hands-on tutorial where you'll learn GitLab's project planning and organization features by building TaskMaster, a personal task management web application. This tutorial focuses on proper project setup and planning using GitLab's powerful tools.

You'll learn how to:
1. Set up project structure in GitLab
2. Use GitLab's planning tools to organize work
3. Break down features into manageable tasks
4. Track progress effectively
5. Collaborate using GitLab's features

## Part 1: Initial Setup & Project Structure

### Step 1: Create the Project

Now that we have our group set up, let's create our main project:

1. From your group page, click the "New project" button
2. Select "Create blank project"
3. Configure the project:
   - Project name: `taskmaster`
   - Project URL: Will auto-populate based on name
   - Initialize repository with a README: Yes
4. Click "Create project"

### Step 2: Project Organization

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

### Step 3: Create Milestones

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

### Step 4: Create Issues for Features

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

> **💡 Tip**: Notice how we use issue weights to indicate relative complexity/effort. This helps in sprint planning and workload management.

### Step 5: Set Up Issue Board

Let's create a board to visualize and manage our workflow:

1. Go to **Plan** > **Boards**
2. Click "Create first board" (or "New board" if you already have one)
3. Name it "Development workflow"
4. Click "Create board"
5. Set up the following lists (click the plus icon to add new lists):

   - **Open** (default list)
   - **Planning** (create list for label `status::planning`)
   - **In Progress** (create list for label `status::in-progress`)
   - **Review** (create list for label `status::review`)
   - **Done** (create list for label `status::done`)

6. Optional: Click the gear icon ⚙️ next to the board name to configure board settings:
   - Enable "Show the Milestone in each issue card"
   - Enable "Show labels in each issue card"

Now you have a Kanban-style board that visualizes your workflow! Try these actions:

1. Drag an issue from "Open" to "Planning"
   - Notice how the label automatically changes
2. Click an issue to view/edit it without leaving the board
3. Use the filters at the top to:
   - Show only MVP milestone issues
   - Show only high priority issues
   - Show only feature-type issues

> **💡 Tip**: Issue boards are real-time collaborative. If you're working with a team, everyone sees updates instantly when cards are moved.
---
<br />

## [<<Previous](1-onboarding.md) &nbsp;&nbsp; [>>Next](3-implementation-merge-requests.md)  
