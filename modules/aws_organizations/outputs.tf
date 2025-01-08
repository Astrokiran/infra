output "organization_id" {
  description = "AWS Organization ID"
  value       = aws_organizations_organization.org.id
}

output "development_ou_id" {
  description = "Development Organizational Unit ID"
  value       = aws_organizations_organizational_unit.development_ou.id
}

output "production_ou_id" {
  description = "Production Organizational Unit ID"
  value       = aws_organizations_organizational_unit.production_ou.id
}