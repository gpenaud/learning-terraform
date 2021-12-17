provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "dev"

  assume_role {
    role_arn = "arn:aws:iam:639130796919:role:terraform_role"
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "prod"

  assume_role {
    role_arn = "arn:aws:iam:032823347814:role:terraform_role"
  }
}

# ==============================================================================

resource "aws_vpc" "master_vpc" {
  provider   = aws.dev
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "master vpc"
  }
}

resource "aws_vpc" "dev_vpc" {
  provider   = aws.prod
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "dev vpc"
  }
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "prod vpc"
  }
}
