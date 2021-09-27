resource "aws_iam_user" "upload" {
  name = "upload"
}

resource "aws_iam_policy" "upload_policy" {
  name        = "upload_policy"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = [
                "arn:aws:s3:::${aws_s3_bucket.data.id}",
                "arn:aws:s3:::${aws_s3_bucket.data.id}"
                  ]
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "upload_attach" {
  user       = aws_iam_user.upload.name
  policy_arn = aws_iam_policy.upload_policy.arn
}

# Download policy

# S3 Bucket

resource "aws_s3_bucket" "data" {
  bucket = "bashful-bucket12312"
  acl    = "private"

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_public_access_block" "data" {
  bucket = aws_s3_bucket.data.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.data
  ]
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "bashful-logs-123321"
  acl    = "log-delivery-write"

  force_destroy = true

  # server_side_encryption_configuration {
  #   rule {
  #     apply_server_side_encryption_by_default {
  #       sse_algorithm = "aws:kms"
  #     }
  #   }
  # }
}


resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.log_bucket
  ]
}