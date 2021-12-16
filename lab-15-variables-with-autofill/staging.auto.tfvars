region_name   = "eu-west-1"
port_list     = ["80", "443", "8443"]
instance_size = "t3.nano"

tags = {
  owner       = "Guillaume Penaud"
  environment = "staging"
  project     = "phoenix"
  code        = "2707"
}
