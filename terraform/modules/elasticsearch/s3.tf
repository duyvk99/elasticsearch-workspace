# # Create s3 user
# resource "aws_iam_user" "iam_user" {
#   name = "${var.name}-elasticsearch-user"
# }

# resource "aws_iam_access_key" "iam_key" {
#   user = aws_iam_user.iam_user.name
# }

# # Create s3 bucket
# resource "aws_s3_bucket" "s3_bucket" {
#   bucket = "${var.name}-elasticsearch-snapshot"

# }

# resource "aws_s3_bucket_cors_configuration" "cors" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["PUT", "POST", "GET", "DELETE"]
#     allowed_origins = ["*"]
#     expose_headers  = []
#     max_age_seconds = 3000
#   }
# }

# resource "aws_s3_bucket_policy" "allow_access" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   policy = data.aws_iam_policy_document.private_access.json
# }

# resource "aws_s3_bucket_public_access_block" "public_access_block" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_acl" "acl" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.owner,
#     aws_s3_bucket_public_access_block.public_access_block,
#   ]

#   bucket = aws_s3_bucket.s3_bucket.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_ownership_controls" "owner" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# # Bucket policy
# data "aws_iam_policy_document" "private_access" { # Convert policy to json

#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_user.iam_user.arn]
#     }


#     resources = [aws_s3_bucket.s3_bucket.arn]

#     actions = [
#         "s3:ListBucket",
#         "s3:GetBucketLocation",
#         "s3:ListBucketMultipartUploads",
#         "s3:ListBucketVersions"
#     ]
#   }

#   statement {
#     principals {
#       type        = "AWS"
#       identifiers = [aws_iam_user.iam_user.arn]
#     }


#     resources = [format("%s/%s", aws_s3_bucket.s3_bucket.arn, "*")]

#     actions = [
#         "s3:GetObject",
#         "s3:PutObject",
#         "s3:DeleteObject",
#         "s3:AbortMultipartUpload",
#         "s3:ListMultipartUploadParts"
#     ]
#   }
# }
