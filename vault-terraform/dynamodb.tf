resource "aws_dynamodb_table" "vault-dynamodb-table" {
  name           = "vault-secrets"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "Path"
  range_key      = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  tags = {
    Name = "vault-secrets-db"
    Purpose = "Storing vault secrets in DynamoDB table"
  }
}