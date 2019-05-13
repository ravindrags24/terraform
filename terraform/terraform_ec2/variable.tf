variable "aws_region" {
  default = "us-east-1"
}

variable "key_pair" {
  default = "abc"
}

variable "subnet_id" {
  default = "subnet-31111152"
}

variable "security_group" {
  default = "sg-xxxxx4ca"

}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_ami" {
  default = "ami-0a313d6098716f372"
}

variable "testing_bucket" {
  default = "testing-develop"
}