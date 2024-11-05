#! /bin/bash -e

sudo mv /tmp/user-data.sh /opt/user-data.sh

# Install the CNI Plugins
curl -L https://github.com/containernetworking/plugins/releases/download/v0.9.1/cni-plugins-linux-amd64-v0.9.1.tgz -o /tmp/cni.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf /tmp/cni.tgz

# Install Nomad
sudo apt-get update && \
  sudo apt-get install wget gpg coreutils unzip -y

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install nomad -y

# Create Nomad directory.
sudo mkdir -p /etc/nomad.d

# Install Vault
sudo apt-get install vault -y

# Create Vault directory.
sudo mkdir -p /etc/vault.d

# Install Boundary
sudo apt-get install -y boundary

# Create Boundary directory.
sudo mkdir -p /etc/boundary.d

# Install Consul
sudo apt-get install consul -y

# Create Consul directory.
sudo mkdir -p /etc/consul.d

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Install Java
sudo apt install default-jre -y