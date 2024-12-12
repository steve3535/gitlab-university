## Install of team's gitlab instance  
* create the gitlab directory with its subdirs in your group home directoy: */srv/teamX*:
  ```
  mkdir -pv gitlab/{log,data,config}
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


   
  
