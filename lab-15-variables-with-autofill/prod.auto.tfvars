region_name   = "ca-central-1"
port_list     = ["80", "443", "8443"]
instance_size = "t2.micro"

tags = {
  owner       = "Guillaume Penaud"
  environment = "prod"
  project     = "phoenix"
  code        = "1808"
}
