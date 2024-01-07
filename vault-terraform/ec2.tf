data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_instance" "vault-secrets" {
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = "t3.micro"
  key_name                    = "payerskey"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.vpc_security_group_ids]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.vault-kms-instance-profile.name
  user_data                   = templatefile("${path.module}/templates/vault.sh.tpl", {
    region              = "var.region"
    dynamodb-table      = aws_dynamodb_table.vault-dynamodb-table.name
    unseal-key          = aws_kms_key.vault-kms-key.arn
    instance-role       = aws_iam_instance_profile.vault-kms-instance-profile.name
    vault_instance_role = "aws:arn:iam::${data.aws_caller_identity.current.account_id}:role/vault-kms-unseal-role"
    s3_bucket_name        = "var.s3_bucket_name"
    secret_token_id     = aws_secretsmanager_secret.vault-secretrootstore.id
    secret_recovery_id    = aws_secretsmanager_secret.vault-secret_recovery_id.id
    })
  
  root_block_device {
    volume_size = 20
  }

  depends_on = [aws_kms_key.vault-kms-key, aws_dynamodb_table.vault-dynamodb-table]

  tags = {
    Name = "vault-secret-instance"
  }
}



resource "aws_secretsmanager_secret" "vault-secretrootstore" {
  name                    = "vault-root-secret-store"
  description             = "vault-root-secret-store"
  recovery_window_in_days = 0

  tags = {
    name    = "vault-root-secret-store"
    Purpose = "Storing vault root secrets in AWS secrets manager"
  }
}

resource "aws_secretsmanager_secret" "vault-secret_recovery_id" {
  name                    = "vault-recovery-key-store"
  description             = "vault-recovery-key-store"
  recovery_window_in_days = 0

  tags = {
    name    = "vault-recovery-key-store"
    Purpose = "Storing vault recovery keys in AWS secrets manager"
  }
}