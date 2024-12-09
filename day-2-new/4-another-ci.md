## Step 1: Create a New GitLab Project

1. Log in to your GitLab account.
2. Navigate to your dashboard by clicking the GitLab logo.
3. Select **New Project** and choose **Create Blank Project**.
4. Name the project `car-assembly`.
5. Set the visibility:
   - **Private**: Only you can access it.
   - **Public**: Share the project with others (optional for this tutorial).
6. Initialize the repository with a **README.md** file.
7. Click **Create Project**.

---

## Step 2: Open the GitLab Web IDE

1. Inside your project, locate the **Edit** button and click on **Web IDE**.
   - **Shortcut**: Press the `.` key on your keyboard to open the Web IDE directly.
2. In the Web IDE, create a new file named `.gitlab-ci.yml`. This file will define your pipeline.

---

## Step 3: Define the GitLab Pipeline

### Add a Job in `.gitlab-ci.yml`

1. Open `.gitlab-ci.yml` in the Web IDE.
2. Define your first job:

```yaml
# .gitlab-ci.yml
build_car:
  image: alpine
  script:
    - echo "Building the car"
    - mkdir build
    - cd build
    - touch car.txt
    - echo "chassis" > car.txt
```

### Explanation:

- **Job Name (`build_car`)**: The name of the task.
- **Image (`alpine`)**: Specifies the Docker image for the environment.
- **Script**: A list of commands to run inside the environment.
  - `echo "Building the car"`: Prints a message.
  - `mkdir build`: Creates a new directory named `build`.
  - `cd build`: Changes the directory to `build`.
  - `touch car.txt`: Creates an empty file named `car.txt`.
  - `echo "chassis" > car.txt`: Writes the text `chassis` to `car.txt`.

---

## Step 4: Commit and Run the Pipeline

1. Save the `.gitlab-ci.yml` file in the Web IDE.
2. Write a commit message (e.g., `Add build_car job`) and commit the changes directly to the `main` branch.
3. Navigate back to your project dashboard.
4. Refresh the page to see the pipeline status. You should see a pipeline running.

---

## Step 5: View the Pipeline Output

1. Click on the pipeline ID or status icon to view details.
2. Inside the pipeline details, click on the **build_car** job.
3. Examine the job logs:
   - Verify messages like `Building the car`, `mkdir build`, and `touch car.txt` appear in the logs.
   - Ensure there are no errors.

---

## Step 6: Understand the Pipeline Concept

- A **Pipeline** consists of one or more **Jobs**.
- Each **Job** performs specific tasks and runs in an isolated environment (Docker container).
- **Stages** organize jobs. In this example, we only defined one stage (`build`), but you can add more (e.g., `test`).

---

## Learning point: 
- **Key Concepts**:
  - GitLab does not save anything unless explicitly told.
  - Files created during a pipeline are not committed to the repository by default.

---

## Inspecting Files in the Build Directory
- **Command**:
  - Use `cat car.txt` to view the file contents.

### Outcome:
- Successfully created `car.txt` with contents.
- Manual process identified as inefficient.

---

## Automating File Verification
- **Objective**:
  - Use Linux commands to automate checks for file existence and content.
- **Commands**:
  - `test -f build/car.txt`: Checks if the file exists.
  - `grep chassis build/car.txt`: Searches for specific content.

---

## Adding a New Job: `test_car`
- **Configuration**:
  - Define a job to test the file:
    ```yaml
    test_car:
      script:
        - test -f build/car.txt
        - grep chassis build/car.txt
    ```

- **Observations**:
  - Pipeline failure occurs if the file or content is missing.
  - Logs reveal the cause of the failure.

---

## Stages in GitLab Pipelines
- **Issue**:
  - Jobs `build_car` and `test_car` run in parallel.
- **Solution**:
  - Define sequential stages: `build` and `test`.
  - Update pipeline configuration:
    ```yaml
    stages:
      - build
      - test

    build_car:
      stage: build

    test_car:
      stage: test
    ```

- **Outcome**:
  - Jobs executed sequentially in the specified order.

---

## Persisting Artifacts Across Jobs
- **Problem**:
  - Docker containers are isolated; files from one job are destroyed after execution.
- **Solution**:
  - Define job artifacts to retain important files:
    ```yaml
    build_car:
      artifacts:
        paths:
          - build/
    ```
- **Behavior**:
  - Artifacts from the `build` stage are accessible in the `test` stage.

---

## Troubleshooting Errors
- **Common Issues**:
  - Incorrect file paths in commands.
  - Overlooked relative paths for `grep`.
- **Fix**:
  - Update commands to include full paths:
    ```bash
    grep chassis build/car.txt
    ```

---

## Final Pipeline Configuration
- **Pipeline Structure**:
  - Two stages: `build` and `test`.
  - Jobs assigned to appropriate stages.
- **Execution Flow**:
  - Jobs run sequentially, ensuring dependencies are met.
- **Visualization**:
  - Pipeline executes from left to right, stage by stage.

---

## Key Learnings
- Use **stages** to manage job execution order.
- Use **artifacts** to persist files between jobs.
- Debugging requires careful log examination.
- Linux commands like `test` and `grep` enhance automation.

---

# Detailed Slide: Understanding GitLab Pipelines with Car Assembly Example

---

## Overview of the Project

- **Repository Content**:
  - Contains `GitLab file` and `README`.
  - Does **not** include `build` directory or `car.txt` file.
- **Key Concept**:
  - GitLab does not save anything unless explicitly told.
  - Files created during a pipeline are not committed to the repository by default.

---

## Inspecting Files in the Build Directory

- **Command**:
  - Use `cat car.txt` to view the file contents.
- **Pipeline Behavior**:
  - Displays latest commit message.
  - Small pipelines complete quickly.

### Outcome:

- Successfully created `car.txt` with contents.
- Manual process identified as inefficient.

---

## Automating File Verification

- **Objective**:
  - Use Linux commands to automate checks for file existence and content.
- **Commands**:
  - `test -f build/car.txt`: Checks if the file exists.
  - `grep chassis build/car.txt`: Searches for specific content.

---

## Adding a New Job: `test_car`

- **Configuration**:

  - Define a job to test the file:
    ```yaml
    test_car:
      script:
        - test -f build/car.txt
        - grep chassis build/car.txt
    ```

- **Observations**:

  - Pipeline failure occurs if the file or content is missing.
  - Logs reveal the cause of the failure.

---

## Stages in GitLab Pipelines

- **Issue**:

  - Jobs `build_car` and `test_car` run in parallel.

- **Solution**:

  - Define sequential stages: `build` and `test`.
  - Update pipeline configuration:
    ```yaml
    stages:
      - build
      - test

    build_car:
      stage: build

    test_car:
      stage: test
    ```

- **Outcome**:

  - Jobs executed sequentially in the specified order.

---

## Persisting Artifacts Across Jobs

- **Problem**:
  - Docker containers are isolated; files from one job are destroyed after execution.
- **Solution**:
  - Define job artifacts to retain important files:
    ```yaml
    build_car:
      artifacts:
        paths:
          - build/
    ```
- **Behavior**:
  - Artifacts from the `build` stage are accessible in the `test` stage.

---

## Troubleshooting Errors

- **Common Issues**:
  - Incorrect file paths in commands.
  - Overlooked relative paths for `grep`.
- **Fix**:
  - Update commands to include full paths:
    ```bash
    grep chassis build/car.txt
    ```

---

## Final Pipeline Configuration

- **Pipeline Structure**:
  - Two stages: `build` and `test`.
  - Jobs assigned to appropriate stages.
- **Execution Flow**:
  - Jobs run sequentially, ensuring dependencies are met.
- **Visualization**:
  - Pipeline executes from left to right, stage by stage.

---

## Key Learnings

- Use **stages** to manage job execution order.
- Use **artifacts** to persist files between jobs.
- Debugging requires careful log examination.
- Linux commands like `test` and `grep` enhance automation.

---

## Summary

- Implemented a simple GitLab pipeline for car assembly.
- Automated file verification and ensured proper job sequencing.
- Learned to troubleshoot and refine pipeline configurations effectively.

---

## Exercise

You are tasked to create a GitLab pipeline for processing a product inventory.

### Repository Setup
- Repository contains:
  ```plaintext
  .gitlab-ci.yml
  README.md
  inventory/
  ```
- The `inventory/` folder includes a file `products.txt` with:
  ```
  ProductA- 10
  ProductB- 20
  ProductC- 30
  ```

### 1. Pipeline Requirements
- Create two stages:
  - `prepare`: Prepares the environment and processes raw data.
  - `validate`: Verifies the processed data.

- Define jobs for each stage:
  - **prepare_inventory**:
    - Copies `products.txt` to `processed/`.
    - Updates the file format (e.g., replaces `-` with `:`).
  - **validate_inventory**:
    - Verifies `products.txt` exists.
    - Ensures all products have numeric values using `grep`.


