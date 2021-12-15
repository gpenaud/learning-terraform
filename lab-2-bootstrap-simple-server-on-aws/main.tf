
provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "web" {
  ami                    = "ami-0bae7412735610274"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = <<EOF
#! /bin/bash
yum -y update
yum -y install httpd
MYIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>webserver with private ip: $MYIP</h2><br>built by terraform" > /var/www/html/index.html
service httpd start
chkconfig httpd on
EOF

  tags = {
    name  = "webserver-by-terraform"
    owner = "Guillaume Penaud"
  }
}

resource "aws_security_group" "web" {
  name        = "webserver-sg"
  description = "security group for my webserver"

  ingress {
    description = "allow http port (80) on ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https port (443) on ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
