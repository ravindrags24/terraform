resource "aws_instance" "testing_test" {
  ami = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${var.subnet_id}"
  key_name = "${var.key_pair}"
  security_groups = ["${var.security_group}"]
  associate_public_ip_address = "true"

  tags {
    Name = "testing_test"
    Owner = "testing"
    Function = "development"
  }
}

resource "aws_s3_bucket" "testing" {
  bucket = "${var.testing_bucket}"
  acl = "private"

  tags {
    Name = "${var.testing_bucket}"
    Owner = "testing"
    Function = "development"
  }
}