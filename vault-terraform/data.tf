# data "template_file" "vault-kms-unseal" {
#   template = "${file("$../templates/vault.sh.tpl")}"

#   vars = {
#     region              = var.region
#     dynamodb-table      = aws_dynamodb_table.vault-dynamodb-table.name
#     unseal-key          = aws_kms_key.vault-kms-key.arn
#     instance-role       = aws_iam_instance_profile.vault-kms-unseal-profile.name
#     vault_instance_role = "aws:arn:iam::${data.aws_caller_identity.current.account_id}:role/vault-kms-unseal-role"
#     vault_bucket        = var.s3_bucket_name
#     secret_token_id     = aws_secretsmanager_secret.vault-secretrootstore.id
#     secret_token_key    = aws_secretsmanager_secret.vault-secretrootstore.id
#   }
# }