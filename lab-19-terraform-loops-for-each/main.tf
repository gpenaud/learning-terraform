provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "user" {
  for_each = toset(var.aws_users)
  name     = each.value
}

resource "aws_instance" "servers_by_env" {
  for_each      = toset(["dev", "staging", "prod"])
  ami           = "ami-00f7e5c52c0f43726"
  instance_type = "t3.micro"
  tags = {
    name  = "server ${each.value}"
    owner = "Guillaume Penaud"
  }
}

resource "aws_instance" "servers_defined_by_variables" {
  for_each      = var.server_settings
  ami           = each.value["ami"]
  instance_type = each.value["instance_type"]

  root_block_device {
    volume_size = each.value["root_disksize"]
    encrypted   = each.value["encrypted"]
  }

  volume_tags = {
    name = "disk-${each.key}"
  }

  tags = {
    name  = "server-${each.key}"
    owner = "Guillaume Penaud"
  }
}
