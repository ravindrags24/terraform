resource "aws_kms_key" "vault-kms-key" {
  description             = "vault-kms-key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-kms-key"
  }
}