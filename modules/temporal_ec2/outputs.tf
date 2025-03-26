output "instance_public_ip" {
  value       = aws_instance.temporal.public_ip
  description = "Public IP of the Temporal EC2 instance"
}

output "instance_id" {
  value       = aws_instance.temporal.id
  description = "ID of the Temporal EC2 instance"
} 