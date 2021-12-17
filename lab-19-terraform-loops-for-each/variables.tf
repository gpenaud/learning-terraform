variable "aws_users" {
  description = "aws iam users to create"
  default = [
    "guillaume.penaud@gmail.com",
    "tony.pasquet@gmail.com",
    "yann.lalaoui@gmail.com",
    "olivier.coffin@gmail.com"
  ]
}

variable "server_settings" {
  default = {
    web = {
      ami           = "ami-00f7e5c52c0f43726"
      instance_type = "t3.small"
      root_disksize = 20
      encrypted     = true
    }
    app = {
      ami           = "ami-00f7e5c52c0f43726"
      instance_type = "t3.micro"
      root_disksize = 10
      encrypted     = false
    }
  }
}
