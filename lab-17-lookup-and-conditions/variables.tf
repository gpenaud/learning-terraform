variable "env" {
  description = "the environment in which to deploy project"
  default     = "prod"
}

variable "server_size" {
  description = "the size of the server"
  default = {
    prod    = "t3.large"
    staging = "t3.medium"
    dev     = "t3.small"
    default = "t3.nano"
  }
}

variable "ami_id_per_region" {
  description = "a custom amazon ami per region"
  default = {
    "us-west-1"  = "ami-03af6a70ccd8cb578"
    "us-west-2"  = "ami-00f7e5c52c0f43726"
    "eu-west-1"  = "ami-04dd4500af104442f"
    "ap-south-1" = "ami-052cef05d01020f1d"
  }
}

variable "allow_port" {
  description = "port allowed by env"
  default = {
    prod    = ["80", "443"]
    default = ["80", "443", "8080", "22"]
  }
}

variable "tags" {
  default = {
    owner   = "Guillaume Penaud"
    project = "lab-17-lookup-and-conditions"
  }
}
