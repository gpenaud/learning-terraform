
variable "region_name" {
  description = "region where you want to provision this EC2 webserver"
  type        = string
  default     = "ca-central-1"
}

variable "port_list" {
  description = "list of port to open for our webserver"
  type        = list(any)
  default     = ["80", "443"]
}

variable "instance_size" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "tags to apply to resources"
  type        = map(any)
  default = {
    owner       = "Guillaume Penaud"
    environment = "prod"
    project     = "phoenix"
  }
}
