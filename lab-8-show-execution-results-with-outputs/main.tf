
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.generic.id]
  tags                   = { name = "web server" }
}

resource "aws_instance" "app" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.generic.id]
  tags                   = { name = "app server" }
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

output "generic_security_group_id" {
  description = "generic security group id for my servers"
  value       = aws_security_group.generic.id
}

output "generic_security_group_all_details" {
  description = "all details of the generic security group for my servers"
  value       = aws_security_group.generic
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}
