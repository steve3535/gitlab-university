In our previous setup with dynamic review environments, we encountered a challenge:  
once a merge request is merged or closed, the review environment continues to exist unnecessarily. This tutorial will show you how to automatically clean up review environments when they're no longer needed.

## The Problem

When we create dynamic review environments:
1. Each merge request gets its own environment
2. Environment remains active even after merging/closing the merge request
3. Manual cleanup is required, which is not efficient
4. Resources are wasted on unused environments

## Adding Environment Cleanup

Let's enhance our pipeline to automatically clean up review environments. Here's how to modify your `.gitlab-ci.yml`:

```yaml
deploy_review:
  image: andthensome/alpine-surge-bash
  stage: review
  script:
    - surge --domain review-${CI_COMMIT_REF_SLUG}-${CI_PROJECT_PATH_SLUG}.surge.sh ./public
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: https://review-${CI_COMMIT_REF_SLUG}-${CI_PROJECT_PATH_SLUG}.surge.sh
    on_stop: stop_review    # Link to the cleanup job
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: always
    - when: never 
stop_review:
  image: andthensome/alpine-surge-bash
  stage: review
  variables:
    GIT_STRATEGY: none    # Don't clone the repository
  script:
    - surge teardown review-${CI_COMMIT_REF_SLUG}-${CI_PROJECT_PATH_SLUG}.surge.sh
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    action: stop
  when: manual
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
      when: always
    - when: never
```

Let's break down the important additions:

### 1. In the deploy_review job:
```yaml
  environment:
    name: review/$CI_COMMIT_REF_SLUG
    url: https://review-${CI_COMMIT_REF_SLUG}-${CI_PROJECT_PATH_SLUG}.surge.sh
    on_stop: stop_review    # Links to the cleanup job
```
- `on_stop: stop_review` tells GitLab which job to run when stopping the environment

### 2. The stop_review job:
```yaml
variables:
  GIT_STRATEGY: none    # Important when branch might be deleted
```
- `GIT_STRATEGY: none` prevents GitLab from trying to clone the repository
- This is crucial because the branch might be deleted when cleanup runs

```yaml
environment:
  name: review/$CI_COMMIT_REF_SLUG
  action: stop
```
- Must match the environment name in deploy_review
- `action: stop` marks this as an environment cleanup job

```yaml
when: manual
```
- Makes the job manual but still allows GitLab to trigger it automatically on merge

## How It Works

1. When you create a merge request:
   - `deploy_review` creates a new environment
   - Environment is linked to `stop_review` job via `on_stop`

2. When the merge request is merged or closed:
   - GitLab automatically triggers the `stop_review` job
   - Job runs `surge teardown` to remove the environment
   - Environment is marked as stopped in GitLab

## Important Notes

1. Environment Name Matching:
   - The environment name must match exactly between `deploy_review` and `stop_review`
   - Both jobs must use the same `$CI_COMMIT_REF_SLUG` variable

2. The `GIT_STRATEGY: none` Variable:
   - Essential when branch might be deleted
   - Prevents GitLab from trying to clone non-existent branches
   - Only defined in `stop_review` job

3. Manual but Automatic:
   - `when: manual` means the job can be triggered manually
   - GitLab can still trigger it automatically on merge/close
   - Provides flexibility in environment cleanup

4. Scope Control:
   - Both jobs use `only: merge_requests`
   - Prevents running on main branch or other branches
   - Ensures cleanup jobs only run for review environments

## Testing the Setup

1. Create a new merge request:
   ```bash
   git checkout -b feature/new-feature
   git push origin feature/new-feature
   ```

2. Verify environment creation:
   - Check the environment URL in the merge request
   - Confirm the site is accessible

3. Merge the request:
   - Watch the pipeline
   - Observe the automatic trigger of `stop_review`
   - Verify the environment is removed (URL should return 404)

## Troubleshooting

1. Environment not cleaning up:
   - Check environment names match exactly
   - Verify `on_stop` points to correct job name
   - Ensure `GIT_STRATEGY: none` is set

2. Job fails to run:
   - Check pipeline logs for errors
   - Verify surge credentials are available
   - Confirm domain name construction is correct

## Best Practices

1. Always include cleanup jobs for dynamic environments
2. Use `GIT_STRATEGY: none` for cleanup jobs
3. Match environment names exactly
4. Test the cleanup process before implementing widely
5. Monitor environment resource usage

This setup ensures your GitLab environments stay clean and resources are properly managed. The automation removes the burden of manual cleanup while maintaining full control over the process when needed.
