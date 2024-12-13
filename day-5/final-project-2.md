## Validate the infra -- follow up 
### Kubernetes
* set your credentials:
  copy the below content in .kube/config file under your home directory:
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJkakNDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdGMyVnkKZG1WeUxXTmhRREUzTXpJMk5UZ3lPREF3SGhjTk1qUXhNVEkyTWpFMU9EQXdXaGNOTXpReE1USTBNakUxT0RBdwpXakFqTVNFd0h3WURWUVFEREJock0zTXRjMlZ5ZG1WeUxXTmhRREUzTXpJMk5UZ3lPREF3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFSckdQYmRIR0FPcHBoRzAzSDhRMWhJSVM4UlcxZFJMbUpESHlybWt4MWUKTlVSVzFPa2JOYVpXQWhudlo3S2FwdVdOZmlVMW9wNzU0RDFjNzN0M2g1QTVvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVTFYMHo0ckRTQUthL3p3SnpaVjYrCkNxeGd6TXd3Q2dZSUtvWkl6ajBFQXdJRFJ3QXdSQUlnQ3ZiTVFSTjJLNVcvaTMrUVB0Qy9DRUZHUXpxTGVRR1UKRDhhSVBYd1p1eWtDSUFwZnFaMWtyNkZnL3plVlZyYWVzSUF5eHFxSkh3eUtzUFhrNnV1SDQyMkMKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://127.0.0.1:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrVENDQVRlZ0F3SUJBZ0lJRFBra1B6eTB4REF3Q2dZSUtvWkl6ajBFQXdJd0l6RWhNQjhHQTFVRUF3d1kKYXpOekxXTnNhV1Z1ZEMxallVQXhOek15TmpVNE1qZ3dNQjRYRFRJME1URXlOakl4TlRnd01Gb1hEVEkxTVRFeQpOakl4TlRnd01Gb3dNREVYTUJVR0ExVUVDaE1PYzNsemRHVnRPbTFoYzNSbGNuTXhGVEFUQmdOVkJBTVRESE41CmMzUmxiVHBoWkcxcGJqQlpNQk1HQnlxR1NNNDlBZ0VHQ0NxR1NNNDlBd0VIQTBJQUJMenc0emFzYXpFMStpRmUKcXJWc0crUmM0bUZYTkpkby9oVk1YeTEwY2gydXFvcEZaWnI3SG1VSFF6ZGNHSWV2MmZvTkV6bFZ5aDdzUW1BYgp0amhiN2ZlalNEQkdNQTRHQTFVZER3RUIvd1FFQXdJRm9EQVRCZ05WSFNVRUREQUtCZ2dyQmdFRkJRY0RBakFmCkJnTlZIU01FR0RBV2dCVHJZdXZtWG1UdEJjeGQ0dW9MK0wvakRvbCs2REFLQmdncWhrak9QUVFEQWdOSUFEQkYKQWlFQW1DSmZuVDhkUGQxeE5tUDJUMHJoMERRNU82SVo2czZ5SkFoVmZBYjNFQllDSUVORkJzWlJKUHVhK2trbQpRUGplR0xJeXFIdmE0dis3NDIvTGNKOWhlWGRBCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0KLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJlRENDQVIyZ0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQWpNU0V3SHdZRFZRUUREQmhyTTNNdFkyeHAKWlc1MExXTmhRREUzTXpJMk5UZ3lPREF3SGhjTk1qUXhNVEkyTWpFMU9EQXdXaGNOTXpReE1USTBNakUxT0RBdwpXakFqTVNFd0h3WURWUVFEREJock0zTXRZMnhwWlc1MExXTmhRREUzTXpJMk5UZ3lPREF3V1RBVEJnY3Foa2pPClBRSUJCZ2dxaGtqT1BRTUJCd05DQUFRTTRZSFBtUlRjMFpObUU2WEszdnFRMkZjc2REK3BYbWo2d1MvdWc3M24KYjNRLzZ2WFJvWmxiMDZHOThNMXZKU3QydWJJM1pqZ1AyZFdyclFvM0x4bktvMEl3UURBT0JnTlZIUThCQWY4RQpCQU1DQXFRd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZEJnTlZIUTRFRmdRVTYyTHI1bDVrN1FYTVhlTHFDL2kvCjR3NkpmdWd3Q2dZSUtvWkl6ajBFQXdJRFNRQXdSZ0loQUtvY2gzR2E5U3gveHlCWTc5UXg1TFhQaTRMVnRCcG0KS2RuT2FraXlYblZoQWlFQTA4b0RhVnA4bjBIZWU0YzErdzBWWGJzYXQ1bjdYNERwU25zMG8zeVRQZjg9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSU9vQTJYYUNMZmR6dUFsaEJ4MGpyQnJpRDVzNWlpSG1JU2R6UFJUa1FpdklvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFdlBEak5xeHJNVFg2SVY2cXRXd2I1RnppWVZjMGwyaitGVXhmTFhSeUhhNnFpa1ZsbXZzZQpaUWRETjF3WWg2L1orZzBUT1ZYS0h1eENZQnUyT0Z2dDl3PT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo=
```
**change localhost to kube-master**  
* check the connection: `kubectl version`
* check the cluster:
  ```
  kubectl cluster-info
  kubectl get nodes
  ``` 
* POSITION urself in the team's namespace:
  ```
  kubectl config set-context --namespace team0 --current
  ```
* quick test
  ```
  kubectl run nginx-test --image=nginx
  kubectl get pods

  kubectl expose pod nginx-test --port=80 --type=ClusterIP
  kubectl get svc
  ```
  
### AWS
* connect to the console with your user and confirm you can access EC2
  console login url: https://stevemissoh.signin.aws.amazon.com/console
  user: team0-kwakoulux
  password: Digital-Skills2024
* get your AWS secrets and test access from the CLI
  ```
  aws configure
  # choose eu-central-1
  aws s3 ls
  aws ec2  describe-instances
  ./describe-instances.sh
  ```
* Test an ec2 creation from the CLI
  ```
  # adapt the script
  ./create-ec2.sh
  ```
  **After the test, go to the console and terminate the instance**

### CREATE A CI TO VALIDATE THE INFRA   

  
  
  
