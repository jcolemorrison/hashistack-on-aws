resource "aws_s3_bucket" "boundary" {
  bucket_prefix = "${var.project_name}-boundary-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "boundary" {
  bucket = aws_s3_bucket.boundary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "boundary" {
  description             = "Boundary bucket KMS key"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "boundary" {
  bucket = aws_s3_bucket.boundary.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.boundary.arn
      sse_algorithm     = "aws:kms"
    }
  }
}