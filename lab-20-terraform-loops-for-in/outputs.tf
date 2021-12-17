output "instance_ids" {
  value = aws_instance.servers[*].id
}

output "instance_public_ips" {
  value = aws_instance.servers[*].public_ip
}

output "instance_id_ip" {
  value = [
    for s in aws_instance.servers :
    "server with id: ${s.id} has public ip ${s.public_ip}"
  ]
}

output "instance_id_ip_map" {
  value = {
    for s in aws_instance.servers :
    s.id => s.public_ip
  }
}

output "users_unique_id_arn" {
  value = [
    for u in aws_iam_user.users :
    "user with unique id: ${u.unique_id} has name ${u.name}"
  ]
}

output "users_unique_id_name_map" {
  value = {
    for u in aws_iam_user.users :
    u.unique_id => u.name
    if length(u.name) < 13
  }
}
