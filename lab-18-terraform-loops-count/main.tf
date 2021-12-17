provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "servers" {
  count         = 2
  ami           = "ami-00f7e5c52c0f43726"
  instance_type = "t3.micro"
  tags = {
    name  = "server number ${count.index}"
    owner = "Guillaume Penaud"
  }
}

resource "aws_instance" "bastion" {
  count         = (var.create_bastion == "YES") ? 1 : 0
  ami           = "ami-00f7e5c52c0f43726"
  instance_type = "t3.micro"
  tags = {
    name  = "bastion server"
    owner = "Guillaume Penaud"
  }
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}
