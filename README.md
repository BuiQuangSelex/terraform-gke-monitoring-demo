# Introduction

This repository is aims to build an infrastructure of Selex's platform - an IoT platform for smart electric vehicle. 
This instruction is mostly based on Ubuntu, so that some commands   may not work on the other Unix-like OS.

# Prerequisites
## Terraform
Reference: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

```sh
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform
terraform version
```
## gcloud cli
Reference: https://cloud.google.com/sdk/docs/install
```sh
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
gcloud version
```

## kubectl cli
Reference: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version
```

# Configuration
## Config 
You should config gcloud by logging in first authorize for it using commands below.
```sh
gcloud init
gcloud auth application-default login

# generate SSH key pair
bash scripts/generate_ssh_key.sh

# init terraform
terraform init

# see the plan
terraform plan

# apply the changes
terraform apply
```



## Infrastructure
-  VPC
-  Domain
-  Database MySQL
-  Kubernetes cluster 
-  Container Registry 
-  Load Balancer
-  Compute Engine 
-  Firewall
## Devtools
- Jenkins
- SonarQube
## Logging
- Elastic Search
- Logstash
- Kibana
## Monitor
- Grafana
- Prometheus



## using kubectl connect cluster
```
kubectl --kubeconfig output/kubeconfig  port-forward service/grafana 3000 -n monitoring
```
