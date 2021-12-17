output "instance_ids" {
  value = aws_instance.servers[*].id
}

output "instance_public_ips" {
  value = aws_instance.servers[*].public_ip
}

output "iam_users" {
  value = aws_iam_user.users[*].name
}
