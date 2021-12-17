# ==============================================================================
# PROVIDERS
# ==============================================================================

provider "aws" {
  region = "eu-west-1"
}

# ==============================================================================
# TERRAFORM
# ==============================================================================

terraform {
  backend "s3" {
    bucket = "gp-terraform-tfstate"
    key    = "dev/web/terraform.tfstate"
    region = "eu-west-1"
  }
}

# ==============================================================================
# DATA
# ==============================================================================

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "gp-terraform-tfstate"
    key    = "dev/network/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "latest_amazonlinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ==============================================================================
# RESOURCES
# ==============================================================================

# ec2 instances
# ------------------------------------------------------------------------------

resource "aws_instance" "web" {
  ami                    = data.aws_ami.latest_amazonlinux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_ids[0]
  user_data              = <<EOF
#! /bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>webserver with private ip: $MYIP</h2><br>built by terraform with remote state" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF

  tags = {
    name  = "webserver-by-terraform"
    owner = "Guillaume Penaud"
  }
}

# security groups
# ------------------------------------------------------------------------------

resource "aws_security_group" "web" {
  name        = "webserver-sg"
  description = "security group for my webserver"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "allow http port (80) on ingress"
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

  tags = {
    name  = "webserver-security-group-by-terraform"
    owner = "Guillaume Penaud"
  }
}
