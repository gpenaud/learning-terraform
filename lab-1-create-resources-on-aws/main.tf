
provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-08ca3fed11864d6bb"
  instance_type = "t3.micro"

  tags = {
    name  = "my-ubuntu-server"
    owner = "Guillaume Penaud"
  }
}

resource "aws_instance" "my_amazon" {
  ami           = "ami-04dd4500af104442f"
  instance_type = "t3.micro"

  tags = {
    name  = "my-amazon-server"
    owner = "Guillaume Penaud"
  }
}
