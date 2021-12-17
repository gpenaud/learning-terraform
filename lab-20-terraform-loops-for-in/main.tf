provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "users" {
  for_each = toset(var.aws_users)
  name     = each.value
}

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-00f7e5c52c0f43726"
  instance_type = "t3.micro"
  tags = {
    name  = "server number ${count.index}"
    owner = "Guillaume Penaud"
  }
}
