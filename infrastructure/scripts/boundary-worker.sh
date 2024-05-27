#!/bin/bash

# Install dependencies
dnf install -y dnf-plugins-core

# Add the HashiCorp repository
cat <<- EOF > /etc/yum.repos.d/hashicorp.repo
[hashicorp]
name=HashiCorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF

# Install Boundary
dnf update -y
dnf install -y boundary-enterprise

# Get the public IP address
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Create the Boundary configuration directory
mkdir -p /etc/boundary

# Boundary worker configuration
cat > /etc/boundary/config.hcl <<- EOF
disable_mlock = true

hcp_boundary_cluster_id = "${BOUNDARY_CLUSTER_ID}"

listener "tcp" {
  address = "0.0.0.0:9202"
  purpose = "proxy"
}

worker {
  public_addr = "$${PUBLIC_IP}"
  auth_storage_path = "/etc/boundary"
  tags {
    type = ${WORKER_TAGS}
  }
}
EOF

# Delete worker auth token on shutdown
cat > /etc/boundary/deregister.sh <<- EOF
aws ssm delete-parameter --name "/boundary/worker/${WORKER_NAME}"
EOF

# Create systemd service file
cat > /etc/systemd/system/boundary.service <<- EOF
[Unit]
Description=Boundary Worker
[Service]
ExecStart=/usr/bin/boundary server -config="/etc/boundary/config.hcl"
ExecStop=/etc/boundary/deregister.sh
User=boundary
Group=boundary
[Install]
WantedBy=multi-user.target
EOF

# Adding a system user and group
useradd --system --user-group boundary || true

# Changing ownership of directories and files
chown boundary:boundary -R /etc/boundary
chown boundary:boundary /usr/bin/boundary

# Setting permissions for the systemd service file and managing the service
chmod 664 /etc/systemd/system/boundary.service
systemctl daemon-reload
systemctl enable boundary
systemctl start boundary

# Store worker auth token in SSM
aws ssm put-parameter --name "/boundary/worker/${WORKER_NAME}" --value "$(cat /etc/boundary/auth_request_token)" --type "SecureString" --overwrite
