data "aws_iam_policy_document" "bucket_policy_document" {
  
  statement {
    sid = "AllBuckets"
    effect = "Allow"
    actions = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    sid = "Bucket"
    effect = "Allow"
    actions = ["s3:ListBucket", "s3:ListBucketMultipartUploads"]
    resources = [module.s3_bucket.s3_bucket_arn]
  }
  
  statement {
    sid = "Objects"
    effect = "Allow"
    actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload",
        
    ]
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
  }

  statement {
    sid = "KMS"
    effect = "Allow"
    # Only used when server side encryption enabled on the bucket
    actions = ["kms:GenerateDataKey", "kms:Decrypt"]
    resources = [aws_kms_key.objects.arn]
  }
}

module "iam_policy_bucket_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "bucket_policy_${var.environment}"
  path        = "/"
  description = "Bucket policy for GCSv5 s3 connector"

  policy = data.aws_iam_policy_document.bucket_policy_document.json

  tags = {
    PolicyDescription = "Bucket policy for GCSv5 s3 connector"
  }
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name = "gcsv5-s3-user-${var.environment}"
  create_iam_user_login_profile = false
  create_iam_access_key = true
}

module "iam_group" {
    source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
    name = "gcsv5-s3-group-${var.environment}"
    attach_iam_self_management_policy = false

    group_users = [
        module.iam_user.iam_user_name
    ]

    custom_group_policies = [
        {
            name = "S3AllowGCSv5Connector-${var.environment}"
            policy = module.iam_policy_bucket_policy.policy
        }
    ]
}
