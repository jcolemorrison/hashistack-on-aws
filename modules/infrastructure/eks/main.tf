resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Enable encryption for k8s secrets
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_cluster.arn
    }
    resources = ["secrets"]
  }

  # depends_on = [
  #   aws_iam_role_policy_attachment.eks_cluster,
  #   aws_kms_key.eks_cluster
  # ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.private_subnet_ids
  version         = var.eks_cluster_version

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  remote_access {
    ec2_ssh_key = var.eks_remote_access_ec2_kepair_name // replace with your key pair name

    # Note: to access the EKS managed node group security group, use aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id
    source_security_group_ids = [
      var.eks_remote_access_security_group_id,
    ]
  }

  update_config {
    max_unavailable = var.node_group_max_unavailable
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = merge(
    { Name = "${var.cluster_name}-node" },
    var.node_group_tags
  )
}
