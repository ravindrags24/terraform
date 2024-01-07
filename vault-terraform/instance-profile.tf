data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault-kms-unseal" {
  statement {
    sid    = "VaultKMSUnseal"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "VaultDynamodDB"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable"
    ]

    resources = [
      "aws_dynamodb_table.vault-dynamodb-table.arn",
    ]
  }
  statement {
    sid       = "IAMPolicy"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKeys",
      "sts:AssumeRole"
    ]
  }
  statement {
    sid       = "s3AccessForFiles"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    actions = [
      "s3:GetObject"
    ]
  }
  statement {
    sid       = "SecretManagerToStoreSecrets"
    effect    = "Allow"
    resources = [aws_secretsmanager_secret.vault-secretrootstore.id, aws_secretsmanager_secret.vault-secret_recovery_id.id]
    actions = [
      "secretmanager:GetSecretValue",
      "secretmanager:UpdateSecret"
    ]
  }
}

resource "aws_iam_role" "vault-kms-unseal-role" {
  name               = "vault-kms-unseal-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name    = "vault-kms-unseal-role"
    Purpose = "Role to allow Vault to access KMS and DynamoDB"
  }
}

resource "aws_iam_role_policy" "vault-kms-unseal-policy" {
  name   = "vault-kms-unseal-policy"
  role   = aws_iam_role.vault-kms-unseal-role.id
  policy = data.aws_iam_policy_document.vault-kms-unseal.json
}

resource "aws_iam_instance_profile" "vault-kms-instance-profile" {
  name = "vault-kms-instance-profile"
  role = aws_iam_role.vault-kms-unseal-role.id
}