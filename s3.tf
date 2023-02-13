locals {
  bucket_name = "s3-bucket-for-gcsv5"
  region      = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "objects" {
  description             = "KMS key is used to encrypt bucket objects"
  deletion_window_in_days = 7
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.bucket_name

  force_destroy = var.force_destroy

  # Note: Object Lock configuration can be enabled only on new buckets
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration
#   object_lock_enabled = true
#   object_lock_configuration = {
#     rule = {
#       default_retention = {
#         mode = "GOVERNANCE"
#         days = 1
#       }
#     }
#   }
  
  # Bucket policies
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy = true

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  acl = "private" # "acl" conflicts with "grant" and "owner"
  
  versioning = {
    status     = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.objects.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}
