# Setting Up GitLab Runners

## What is a GitLab Runner?

A GitLab Runner is an agent that runs your CI/CD jobs. It:
- Picks up jobs from the pipeline
- Executes the jobs in the environment specified
- Reports results back to GitLab

## Types of Runners
1. **Shared Runners**
   - Available to all projects in a GitLab instance
   - Managed by GitLab.com administrators
   - Perfect for simple projects and getting started

2. **Specific Runners**
   - Dedicated to specific projects
   - Self-managed
   - Better for specialized needs

## Using GitLab.com Shared Runners

For our TaskMaster project on GitLab.com:

1. Navigate to your project in GitLab
2. Go to **Settings > CI/CD**
3. Expand the **Runners** section
4. Make sure "Enable shared runners for this project" is toggled ON

That's it! GitLab.com provides shared runners by default, so we don't need to set up our own runner.

## Verify Runner Availability

1. Still in **Settings > CI/CD > Runners**
2. You should see under "Shared runners":
   - "Available shared runners"
   - List of runners with "Shared" tag
   - Status should show as "Active"

## Runner Tags

Our simple pipeline doesn't need specific tags, but good to know:
- Runners can have tags (like `docker`, `linux`, etc.)
- Jobs can request specific runners using tags
- Our basic pipeline will work with any runner

## Checking Runner Status in Pipeline

Once we push our pipeline:
1. Go to CI/CD > Pipelines
2. Click on a running/completed pipeline
3. In job details, you'll see which runner picked up the job

## Best Practices

1. 🔄 **For Simple Projects**
   - Use shared runners
   - No special configuration needed

2. 🎯 **Pipeline Efficiency**
   - Keep jobs focused
   - Use caching
   - Clean up after jobs

3. 📊 **Monitoring**
   - Watch pipeline execution times
   - Monitor runner availability

## Troubleshooting

Problem | Solution
--------|----------
No runners available | Check runner section in project settings
Jobs stuck in pending | Verify shared runners are enabled
Runner doesn't pick up jobs | Check job tags match runner tags

