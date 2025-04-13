# Tutorial: Creating Your First GitLab CI/CD Pipeline

**Prerequisites:**
- A GitLab.com account
- A phone number for account verification

## Step 1: Account Verification
Before you can run any pipelines, you need to verify your GitLab account:

1. Navigate to your project
2. When you try to run a pipeline, GitLab will prompt you to verify your account
3. Click "Verify my account"
4. Enter your phone number
5. Complete the verification puzzle
6. Enter the verification code received via SMS
7. Click "Next" to complete verification

> **Note:** Account verification is required to prevent abuse of GitLab's free tier resources.

## Step 2: Github Codespace or Gitlab Web IDE ?
If you use Github Codespace IDE to create our pipeline configuration:  
see #[codespace_configuration]()
Otherwise just select **Edit** > **Web IDE**

## Step 3: Create the Pipeline Configuration
Now we'll create the pipeline configuration file:

1. In the Web IDE, hover over the project root and click the "New file" icon
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

## Step 4: Commit the Pipeline Configuration

## Step 5: View and Run the Pipeline
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


