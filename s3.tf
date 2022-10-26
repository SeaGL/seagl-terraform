resource "aws_s3_bucket" "state" {
  bucket = "seagl-terraform"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 120
    }
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}