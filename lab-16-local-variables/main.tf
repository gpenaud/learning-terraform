provider "aws" {
  region = "us-east-1"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

locals {
  region_fullname = data.aws_region.current.description
  number_of_azs   = length(data.aws_availability_zones.available.names)
}

locals {
  region_info = "this resource is in region ${local.region_fullname}, and consist of ${local.number_of_azs} availability zones"
}

locals {
  tags = {
    owner       = "Guillaume Penaud"
    region_info = local.region_info
  }
}

# ------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.tags, { name = "my vpc" })
}

resource "aws_eip" "my_static_ip" {
  tags = merge(local.tags, { name = "my eip" })
}
