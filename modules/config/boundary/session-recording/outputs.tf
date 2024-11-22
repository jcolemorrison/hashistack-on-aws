output "boundary_session_recording_policy_arn" {
  value = aws_iam_policy.boundary.arn
}

output "boundary_bucket_access_key_id" {
  value = aws_iam_access_key.boundary.id
}

output "boundary_bucket_secret_access_key" {
  value     = aws_iam_access_key.boundary.secret
  sensitive = true
}

output "boundary_bucket" {
  value = aws_s3_bucket.boundary.id
}
