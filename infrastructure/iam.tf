# Fetch the certificate details of the EKS cluster's OIDC provider
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

# Create an IAM OIDC provider for the EKS cluster
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${project_name}-eks-cluster"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.${data.aws_partition.current.dns_suffix}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSVPCResourceController"
}

# Create an IAM role for the EKS node group
resource "aws_iam_role" "eks_node_group" {
  name = "${var.project_name}-node-group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.${data.aws_partition.current.dns_suffix}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_group_fluent_bit" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = aws_iam_policy.fluent_bit.arn
}

# Create an IAM role for Fluent Bit logging
resource "aws_iam_role" "fluent_bit" {
  name = "fluent-bit"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        },
        Condition = {
          StringEquals = {
            "${aws_eks_cluster.cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:logging:fluent-bit"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluent_bit" {
  role       = aws_iam_role.fluent_bit.name
  policy_arn = aws_iam_policy.fluent_bit.arn
}

# Create an IAM role for the AWS Load Balancer Controller
resource "aws_iam_role" "aws_lb_controller" {
  name = "aws-lb-controller"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.oidc_provider.arn
        },
        Condition = {
          StringEquals = {
            "${aws_eks_cluster.cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })
}

# Attach the AWSLoadBalancerControllerIAMPolicy to the AWS Load Balancer Controller role
resource "aws_iam_role_policy_attachment" "aws_lb_controller" {
  role       = aws_iam_role.aws_lb_controller.name
  policy_arn = aws_iam_policy.aws_lb_controller.arn
}

# Define the AWSLoadBalancerControllerIAMPolicy
resource "aws_iam_policy" "aws_lb_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = data.aws_iam_policy_document.aws_lb_controller.json
}