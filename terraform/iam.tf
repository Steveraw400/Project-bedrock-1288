resource "aws_iam_user" "bedrock_dev" {
  name = "bedrock-dev-view"

  tags = local.tags
}

resource "aws_iam_user_policy_attachment" "dev_readonly" {
  user       = aws_iam_user.bedrock_dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Optional – keep only if required by rubric
#resource "aws_iam_access_key" "bedrock_dev_key" {
# user = aws_iam_user.bedrock_dev.name
#}

data "aws_iam_policy_document" "dev_put_assets" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.assets.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListBucketMultipartUploads",
      "s3:ListMultipartUploadParts"
    ]
    resources = [
      "${aws_s3_bucket.assets.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "dev_put_assets" {
  name   = "bedrock-dev-put-assets-1288"
  policy = data.aws_iam_policy_document.dev_put_assets.json
  tags   = local.tags
}

resource "aws_iam_user_policy_attachment" "dev_put_assets" {
  user       = aws_iam_user.bedrock_dev.name
  policy_arn = aws_iam_policy.dev_put_assets.arn
}
