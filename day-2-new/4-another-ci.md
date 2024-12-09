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

### Add a Test Stage (Optional)

Expand your pipeline by adding a test job:

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test

build_car:
  stage: build
  image: alpine
  script:
    - echo "Building the car"
    - mkdir build
    - cd build
    - touch car.txt
    - echo "chassis" > car.txt

test_car:
  stage: test
  image: alpine
  script:
    - echo "Testing the car"
    - cat build/car.txt
```

### Explanation:

- **Stages (`stages`)**: Defines the order of execution.
  - `build`: Executes the `build_car` job.
  - `test`: Executes the `test_car` job.
- **Job (`test_car`)**:
  - Prints the contents of `car.txt` to verify the file.

---

## Step 7: Commit and Verify the Extended Pipeline

1. Commit the changes to `.gitlab-ci.yml`.
2. Navigate to your project dashboard and check the pipeline status.
3. Ensure both `build_car` and `test_car` jobs run successfully.
4. Review the job logs to confirm the pipeline works as expected.

