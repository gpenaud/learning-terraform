# ------------------------------------------------------------------------------
# Terraform - from zero to certified professional
#
# Provision highly available web cluster in any region default vpc
# create:
#   - security group for webserver and elastic load-balancer
#   - launch configuration with auto ami lookup
#   - auto scaling group using 2 availability zones
#   - classic load balancer using 2 avilability zones
#
# update to web servers wille be via blue/green deployment strategy
# developped by Guillaume Penaud
# ------------------------------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
}

data "aws_availability_zones" "working" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*x86_64-gp2"]
  }
}

resource "aws_security_group" "web" {
  name = "web security group"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name  = "web security group"
    owner = "Guillaume Penaud"
  }
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "webserver-highly-available-lc"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "asg-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 3
  max_size             = 3
  min_elb_capacity     = 3
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.id]

  dynamic "tag" {
    for_each = {
      name   = "webserver in asg"
      owner  = "Guillaume Penaud"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true # propagate tags to ec2 launched through autoscaling
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "webserver-highly-available-elb"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    name  = "webserver highly available elb"
    owner = "Guillaume Penaud"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
