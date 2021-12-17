
provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {}

resource "aws_instance" "my_server" {
  ami                    = var.ami_id_per_region[data.aws_region.current.name]
  instance_type          = lookup(var.server_size, var.env, var.server_size["default"])
  vpc_security_group_ids = [aws_security_group.my_server.id]

  root_block_device {
    volume_size = 10
    encrypted   = (var.env == "prod") ? true : false # conditional for simple variable
  }

  dynamic "ebs_block_device" {
    for_each = (var.env == "prod") ? [true] : [] # conditional for whole block
    content {
      device_name = "/dev/sdb"
      volume_size = 40
      encrypted   = true
    }
  }

  volume_tags = { name = "disk-${var.env}" }
  tags = merge(var.tags, {
    name = "${var.env}-server"
  })
}

resource "aws_security_group" "my_server" {
  name        = "my-server-sg"
  description = "security group for my webserver"

  dynamic "ingress" {
    for_each = lookup(var.allow_port, var.env, var.allow_port["default"]) # default ports by lookup
    content {
      description = "allow http port (${ingress.value}) on ingress"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "allow all ports on egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    name = "${var.env}-security-group"
  })
}
