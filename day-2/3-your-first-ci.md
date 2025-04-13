# Tutorial: Creating Your First GitLab CI/CD Pipeline

## Step 1: Create the Pipeline Configuration
Now we'll create the pipeline configuration file:

0. In the Gitlab Web UI, create a project (e.g. demo)
1. Hover over the project root and click the "New file" icon
2. Name the file exactly: `.gitlab-ci.yml` (the leading dot is crucial)
3. Add the following basic configuration:
```yaml
test:
  script:
    - echo "Hello!"
```

This configuration creates:
- A job named `test`
- A single command that prints "Hello!"

## Step 2: Commit the Pipeline Configuration

## Step 3: View and Run the Pipeline
1. Return to your project's main page
2. You should see a pipeline indicator next to your commit
3. Click on the pipeline indicator to view details
4. The pipeline will run automatically and execute your test job
5. When complete, you should see the "Hello!" output in the job logs

## Testing the Pipeline
To verify everything works:

1. Go back to the Web IDE
2. Modify the echo command to say "Hello 2!"
2. Commit the changes
3. A new pipeline will trigger automatically
4. View the pipeline to see your updated message


## [<<Previous](./2d-gitlab-stages.md) &nbsp;&nbsp; [>>Next](./4-another-ci.md)