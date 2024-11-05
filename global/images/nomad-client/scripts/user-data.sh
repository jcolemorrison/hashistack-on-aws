#! /bin/bash -e

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 600")
NODE_POOL=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/NodePool)
AWS_REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)

# Nomad configuration files
cat <<EOF > /etc/nomad.d/nomad.hcl
data_dir = "/etc/nomad.d/data"

client {
  enabled    = true

  server_join {
    retry_join = ["provider=aws region=$AWS_REGION tag_key=NomadServer tag_value=true"]
  }

  node_pool = "$NODE_POOL"
}

plugin "docker" {
  config {
    allow_privileged = false
    allow_caps = [
      "audit_write", "chown", "dac_override", "fowner", "fsetid", "kill", "mknod",
      "net_bind_service", "setfcap", "setgid", "setpcap", "setuid", "sys_chroot",
      "ipc_lock"
    ]
  }
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