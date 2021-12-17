provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  region = "eu-south-1"
  alias  = "europe"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "asia"
}

# ==============================================================================

data "aws_ami" "default_latest_ubuntu20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "europe_latest_ubuntu20" {
  provider    = aws.europe
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "asia_latest_ubuntu20" {
  provider    = aws.asia
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# ==============================================================================

resource "aws_instance" "my_default_server" {
  ami           = data.aws_ami.default_latest_ubuntu20.id
  instance_type = "t3.micro"
  tags = {
    name = "default server"
  }
}

resource "aws_instance" "my_europe_server" {
  provider      = aws.europe
  ami           = data.aws_ami.europe_latest_ubuntu20.id
  instance_type = "t3.micro"
  tags = {
    name = "europe server"
  }
}

resource "aws_instance" "my_asia_server" {
  provider      = aws.asia
  ami           = data.aws_ami.asia_latest_ubuntu20.id
  instance_type = "t3.micro"
  tags = {
    name = "asia server"
  }
}
