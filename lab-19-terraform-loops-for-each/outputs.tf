output "user_arns" {
  value = values(aws_iam_user.user)[*].arn
}

output "prod_instance_by_env_id" {
  value = aws_instance.servers_by_env["prod"].arn
}

output "instance_by_env_ids" {
  value = values(aws_instance.servers_by_env)[*].arn
}
