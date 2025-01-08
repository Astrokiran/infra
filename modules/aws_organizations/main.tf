###########################################
# AWS Organizations Setup
###########################################
resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

###########################################
# Organizational Units (OUs)
###########################################
resource "aws_organizations_organizational_unit" "development_ou" {
  name      = "Development"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "production_ou" {
  name      = "Production"
  parent_id = aws_organizations_organization.org.roots[0].id
}