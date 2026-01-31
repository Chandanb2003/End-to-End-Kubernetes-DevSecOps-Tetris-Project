#!/bin/bash

# Enable logging
exec > /var/log/userdata.log 2>&1
echo "===== Starting Setup at $(date) ====="

# Update system
sudo apt update -y

################################
# Install Java (Required for Jenkins)
################################
echo "Installing Java..."
sudo apt install fontconfig openjdk-21-jre -y
java --version

################################
# Install Jenkins
################################
echo "Installing Jenkins..."
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update -y
sudo apt install jenkins -y

sudo systemctl enable jenkins
sudo systemctl start jenkins

################################
# Install Docker
################################
echo "Installing Docker..."
sudo apt install docker.io -y

sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu

sudo systemctl enable docker
sudo systemctl restart docker

# Avoid permission issues in Jenkins pipelines
sudo chmod 777 /var/run/docker.sock

################################
# SonarQube Container
################################
echo "Starting SonarQube..."
docker run -d --restart unless-stopped \
  --name sonarqube \
  -p 9000:9000 sonarqube:community

################################
# Install Terraform
################################
echo "Installing Terraform..."
sudo apt install unzip -y
sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update -y
sudo apt-get install terraform -y

################################
# Install Kubectl
################################
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/v1.33.5/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

kubectl version --client

################################
# Install AWS CLI v2
################################
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

################################
# Install Trivy (OWASP Scanner)
################################
echo "Installing Trivy..."
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
  gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" | \
sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt update -y
sudo apt install trivy -y

trivy --version

################################
# Final Status
################################
echo "===== Setup Completed at $(date) ====="
