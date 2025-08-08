#!/bin/bash
set -e

# Log output for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update system and install packages
yum update -y
yum install -y docker containerd git screen

# Install Docker Compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
mkdir -p /usr/libexec/docker/cli-plugins
mv docker-compose-$(uname -s)-$(uname -m) /usr/libexec/docker/cli-plugins/docker-compose
chmod +x /usr/libexec/docker/cli-plugins/docker-compose

# Enable and start Docker
systemctl enable docker.service --now

# Add users to docker group
usermod -aG docker ssm-user || true
usermod -aG docker ec2-user || true

# Wait for Docker to be fully ready
sleep 10

# Pull and run the Docker image
docker pull karthik0741/images:petclinic_img
docker run -d \
  -e MYSQL_URL=jdbc:mysql://${mysql_url}/petclinic \
  -e MYSQL_USER=petclinic \
  -e MYSQL_PASSWORD=petclinic \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=petclinic \
  -p 80:8080 \
  docker.io/karthik0741/images:petclinic_img
