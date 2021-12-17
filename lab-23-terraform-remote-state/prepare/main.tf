provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "gp-terraform-tfstate"
  acl    = "private"

  versioning {
    enabled = true
  }
}
