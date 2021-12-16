
provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "working" {}
data "aws_vpcs" "vpcs" {}

data "aws_vpc" "prod" {
  tags = {
    name = "prod"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.1.0/24"

  tags = {
    name = "main"
    info = "AZ: ${data.aws_availability_zones.working.names[0]} in region ${data.aws_region.current.description}"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = data.aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.0.2.0/24"

  tags = {
    name = "main"
    info = "AZ: ${data.aws_availability_zones.working.names[1]} in region ${data.aws_region.current.description}"
  }
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "all_vpc_ids" {
  value = data.aws_vpcs.vpcs.ids
}
