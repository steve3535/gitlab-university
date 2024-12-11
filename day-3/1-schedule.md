When working with GitLab CI/CD pipelines, you'll need to know different ways to trigger and recover pipelines:
- Retrying failed jobs and pipelines
- Running pipelines manually
- Scheduling pipeline runs

## Retrying Failed Jobs

Sometimes pipelines can fail for temporary reasons (network issues, resource constraints, etc). GitLab provides easy ways to retry failed jobs:

### When to Retry Jobs
- Job fails near the end of a long pipeline
- Failure seems unrelated to your code changes
- Infrastructure or temporary issues are suspected

### How to Retry a Failed Job
1. Go to the pipeline view
2. Find the failed job
3. Click the "Retry" button (↺) next to the failed job
4. GitLab will rerun just that specific job
5. If successful, the pipeline will continue from that point

### How to Retry an Entire Pipeline
1. On the pipeline page
2. Click the "Retry" button at the top
3. This reruns the entire pipeline with the same code and configuration

## Running Pipelines Manually

Sometimes you need to run a pipeline without making code changes:

1. Go to your project's **CI/CD > Pipelines** section
2. Click "Run Pipeline"
3. In the form that opens:
   - Select the target branch
   - Add any variables needed (optional)
   - Click "Run Pipeline"

This is useful for:
- Testing pipeline configurations
- Running deployments
- Triggering maintenance tasks
- Re-running builds without code changes

## Scheduling Pipeline Runs

For regular maintenance or testing, you can schedule pipeline runs:

1. Navigate to **CI/CD > Schedules**
2. Click "New schedule"
3. Configure the schedule:
   - Description (optional)
   - Interval options:
     - Custom (using cron syntax)
     - Every day
     - Every week
     - Every month
   - Select target branch
   - Add variables if needed (optional)
4. Click "Save pipeline schedule"

### Common Use Cases for Scheduled Pipelines
- Daily integration tests
- Weekly dependency updates
- Regular security scans
- Periodic deployments
- Maintenance tasks

### Managing Scheduled Pipelines
- You can trigger scheduled pipelines manually from the Schedules page
- Schedules can be paused/resumed as needed
- Review results in the pipeline history

## Best Practices

1. **Retry Strategy:**
   - Don't blindly retry failures
   - Investigate patterns in failures
   - Document known transient issues

2. **Manual Runs:**
   - Use descriptive variable names
   - Document required variables
   - Consider environment impacts

3. **Schedules:**
   - Choose appropriate times (e.g., low-traffic periods)
   - Set up notifications for failures

