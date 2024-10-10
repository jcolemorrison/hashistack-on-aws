resource "boundary_worker" "worker" {
  count       = var.boundary_worker_count
  scope_id    = "global"
  name        = "worker-${count.index}"
  description = "self managed worker with controller led auth"
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Boundary Cluster ID
locals {
  boundary_cluster_id = split(".", replace(var.boundary_address, "https://", ""))[0]
}

resource "aws_instance" "boundary_worker_instance" {
  count = var.boundary_worker_count

  ami                         = data.aws_ssm_parameter.al2023.value
  associate_public_ip_address = true
  instance_type               = var.boundary_worker_instance_type
  iam_instance_profile        = aws_iam_instance_profile.boundary_worker_profile.name
  key_name                    = var.boundary_worker_ec2_kepair_name
  vpc_security_group_ids      = [aws_security_group.boundary_worker.id]

  # constrain to number of public subnets
  subnet_id = var.vpc_public_subnet_ids[count.index % 3]

  user_data = templatefile("${path.module}/scripts/boundary-worker.sh", {
    BOUNDARY_CLUSTER_ID                   = local.boundary_cluster_id
    REGION                                = var.aws_region
    WORKER_TAGS                           = jsonencode(var.worker_tags)
    WORKER_NAME                           = "${var.project_name}-worker-${count.index}"
    CONTROLLER_GENERATED_ACTIVATION_TOKEN = boundary_worker.worker[count.index].controller_generated_activation_token
    INDEX                                 = count.index
    WORKER_ID                             = boundary_worker.worker[count.index].id
  })

  user_data_replace_on_change = true
}