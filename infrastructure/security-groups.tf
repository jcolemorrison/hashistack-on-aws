
resource "aws_security_group" "eks_control_plane" {
  name   = "eks_control_plane"
  vpc_id = module.vpc.id

  ingress {
    description     = "Allow worker nodes to communicate with control plane"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes.id]
  }

  ingress {
    description     = "Allow worker nodes to communicate with kubelet API on control plane"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes.id]
  }

  egress {
    description     = "Allow communication with kubelet and proxy on worker nodes"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes.id]
  }

  egress {
    description     = "Allow communication with kubelet API on worker nodes"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_worker_nodes.id]
  }
}

# Note: to access the EKS managed node group security group, use aws_eks_cluster.cluster.vpc_config.0.cluster_security_group_id