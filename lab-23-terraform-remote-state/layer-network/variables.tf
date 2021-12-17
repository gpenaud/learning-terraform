
variable "env" {
  description = "environment in which deploy resources"
  default     = "dev"
}

variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "public subnet for vpc"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}
