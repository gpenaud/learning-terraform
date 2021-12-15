
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.generic.id]
  tags                   = { name = "web server" }

  depends_on = [
    aws_instance.app,
    aws_instance.db
  ]
}

resource "aws_instance" "app" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.generic.id]
  tags                   = { name = "app server" }

  depends_on = [
    aws_instance.db
  ]
}

resource "aws_instance" "db" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.generic.id]
  tags                   = { name = "db server" }
}

resource "aws_security_group" "generic" {
  name        = "generic-sg"
  description = "generic security group"

  dynamic "ingress" {
    for_each = ["22", "80", "443"]
    content {
      description = "allow http and ssh ports on ingress"
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
    name  = "generic security group"
    owner = "Guillaume Penaud"
  }
}
