#!/bin/bash
# Installs Git, Python, Docker, Java, Jenkins on Ubuntu / WSL2 Ubuntu
set -e
sudo apt update
sudo apt install -y git python3 python3-venv python3-pip curl wget fontconfig openjdk-17-jre docker.io
sudo usermod -aG docker $USER
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt update
sudo apt install -y jenkins
sudo usermod -aG docker jenkins
sudo systemctl enable --now docker jenkins
echo "Jenkins password:"; sudo cat /var/lib/jenkins/secrets/initialAdminPassword
