
provider "aws" {
  region = var.region_name
}

resource "aws_instance" "web" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = var.instance_size
  vpc_security_group_ids = [aws_security_group.web.id]
  tags = merge(var.tags, {
    name = "${var.tags["environment"]} webserver by terraform for project ${var.tags["project"]}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = merge(var.tags, {
    name = "${var.tags["environment"]} eip by terraform for project ${var.tags["project"]}"
  })
}

resource "aws_security_group" "web" {
  name        = "webserver-sg"
  description = "security group for my webserver"

  dynamic "ingress" {
    for_each = var.port_list
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
    name = "${var.tags["environment"]} security group by terraform for project ${var.tags["project"]}"
  })
}
