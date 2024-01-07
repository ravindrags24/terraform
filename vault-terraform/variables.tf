variable "subnet_id" {
  description = "The subnet ID to launch in"
  type        = string
  default     = "subnet-081571ae491c550ac"
}


variable "vpc_security_group_ids" {
  description = "The security group ID to launch in"
  type        = string
  default     = "sg-0e5248d1e58d02fa2"
}

variable "s3_bucket_name" {
  description = "Storing vault configuration file when necessary pull from s3 bucket"
  type        = string
  default     = "vault-configuration-files"
}

variable "region" {
  description = "The region to launch in"
  type        = string
  default     = "us-east-1"
}

