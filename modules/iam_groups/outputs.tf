output "admin_group_name" {
  description = "Admins IAM Group Name"
  value       = aws_iam_group.admins.name
}

output "developers_group_name" {
  description = "Developers IAM Group Name"
  value       = aws_iam_group.developers.name
}

output "production_group_name" {
  description = "Production IAM Group Name"
  value       = aws_iam_group.production.name
}