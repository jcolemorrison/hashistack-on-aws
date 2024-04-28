resource "aws_kms_key" "eks_cluster" {
  description = "KMS key for EKS secrets"
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.eks_kms.json
}