## Install of team's gitlab instance  
* create the gitlab directory with its subdirs in your group home directoy: */srv/teamX*:
  ```
  mkdir -pv gitlab/{log,data,config}
  ```
* put this minimal content in config subfolder (change X by your teams number):
  ``` 
  cat <<EOF >config/gitlab.rb
  external_url "https://teamX-gitlab.thelinuxlabs.com"
  gitlab_rails['gitlab_shell_ssh_port'] = 2424
  letsencrypt['enable'] = false
  nginx['listen_port'] = 80
  nginx['listen_https'] = false
  web_server['external_users'] = ['gitlab-www','git']
  EOF
  ```  
* create the docker-compose file:
  ```
  cd gitlab
  
  cat <<EOF >docker-compose.yaml
  ---
  services:
   gitlab:
     image: gitlab/gitlab-ce:latest
     container_name: teamX-gitlab #change this with your team number
     hostname: 'teamX-gitlab' #change this with your team number
     ports:
     - '222X:22' #change this with your team number
     - '888X:80' #change this with your team number
     volumes:
       - '/srv/teamX/gitlab/config:/etc/gitlab'
       - '/srv/teamX/gitlab/logs:/var/log/gitlab'  
       - '/srv/teamX/gitlab/data:/var/opt/gitlab'
     shm_size: '256m'
     restart: unless-stopped

  docker compose up -d

  docker compose logs -f
  ```
* if after 5 minutes, the status of the container is still unhealthy, then u might hit a 502
  
  Try:   https://teamX-gitlab.thelinuxlabs.com/
  **Resolve the issue by setting a write bit to the file /var/opt/gitlab/gitlab-workhorse/sockets/socket inside the container**

* the initial password is in the file /etc/gitlab/initial_root_password inside the container
* Access the gitlab from the UI, change the password and let your team members register and get approved
  

## Installation of a gitlab runner   
* setup
  ´´´
  # Docker runner installation
  docker run -d --name gitlab-runner-team0 \
  --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v gitlab-runner-config-team0:/etc/gitlab-runner \
  gitlab/gitlab-runner:latest
  ```
* go to the settings in gitlab and create and register the runner
* https://docs.gitlab.com/runner/install/docker.html  

   
  
