variable "aws_users" {
  description = "aws iam users"
  default = [
    "guillaume.penaud@gmail.com",
    "tony.pasquet@gmail.com",
    "yann.lalaoui@gmail.com",
    "olivier.coffin@gmail.com"
  ]
}

variable "create_bastion" {
  description = "decide to create bastion or not (YES/NO)"
}
