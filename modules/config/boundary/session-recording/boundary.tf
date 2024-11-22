resource "boundary_storage_bucket" "boundary" {
  name            = var.project_name
  description     = "Boundary session recordings for ${var.project_name}"
  scope_id        = "global"
  plugin_name     = "aws"
  bucket_name     = aws_s3_bucket.boundary.id
  attributes_json = jsonencode({ "region" = "${var.aws_region}" })

  # recommended to pass in aws secrets using a file() or using environment variables
  # the secrets below must be generated in aws by creating a aws iam user with programmatic access
  secrets_json = jsonencode({
    "access_key_id"     = "${aws_iam_access_key.boundary.id}",
    "secret_access_key" = "${aws_iam_access_key.boundary.secret}"
  })
  worker_filter = "\"${var.project_name}\" in \"/tags/project\""
}
