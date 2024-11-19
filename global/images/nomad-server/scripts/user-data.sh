#! /bin/bash -e

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 600")
NOMAD_SERVER_COUNT=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/NomadServerCount)
AWS_REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)

# Nomad configuration files
cat <<EOF > /etc/nomad.d/nomad.hcl
data_dir = "/etc/nomad.d/data"

server {
  enabled          = true
  bootstrap_expect = $NOMAD_SERVER_COUNT

  server_join {
    retry_join = ["provider=aws region=$AWS_REGION tag_key=NomadServer tag_value=true"]
  }
}

consul {
    server_auto_join = false
    client_auto_join = false
}

autopilot {
    cleanup_dead_servers      = true
    last_contact_threshold    = "200ms"
    max_trailing_logs         = 250
    server_stabilization_time = "10s"
    enable_redundancy_zones   = false
    disable_upgrade_migration = false
    enable_custom_upgrades    = false
}
EOF

cat <<EOF > /etc/nomad.d/acl.hcl
acl = {
  enabled = true
}
EOF

systemctl enable nomad
systemctl restart nomad

echo -e '#!/bin/bash\n echo "HTTP/1.1 200 OK\n\nOK" | nc -l -p 8080' > /usr/local/bin/health-check.sh
sudo chmod +x /usr/local/bin/health-check.sh

cat <<EOF > /etc/systemd/system/health-check.service
[Unit]
Description=Simple Health Check

[Service]
ExecStart=/usr/local/bin/health-check.sh

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start health-check.service
sudo systemctl enable health-check.service