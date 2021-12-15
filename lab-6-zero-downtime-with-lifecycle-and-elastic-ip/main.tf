
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = file("user_data.sh")

  tags = {
    name  = "webserver with static ip"
    owner = "Guillaume Penaud"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    name  = "elastic ip for my webserver"
    owner = "Guillaume Penaud"
  }
}

resource "aws_security_group" "web" {
  name        = "webserver-sg"
  description = "security group for my webserver"

  dynamic "ingress" {
    for_each = ["80", "8080", "443", "8443"]
    content {
      description = "allow http ports on ingress"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "ingress" {
    for_each = ["8000", "9000", "7000"]
    content {
      description = "allow udp ports on ingress"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "allow ssh port (22) on ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
