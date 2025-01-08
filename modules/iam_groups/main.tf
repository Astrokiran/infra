###########################################
# IAM Groups
###########################################
resource "aws_iam_group" "admins" {
  name = "Admins"
}

resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group" "production" {
  name = "Production"
}

###########################################
# IAM Policies for Groups
###########################################
data "aws_iam_policy_document" "admins_policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_group_policy" "admins_policy" {
  name   = "AdminsPolicy"
  group  = aws_iam_group.admins.name
  policy = data.aws_iam_policy_document.admins_policy.json
}

data "aws_iam_policy_document" "developers_policy" {
  statement {
    actions   = ["ec2:*", "s3:*", "rds:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_group_policy" "developers_policy" {
  name   = "DevelopersPolicy"
  group  = aws_iam_group.developers.name
  policy = data.aws_iam_policy_document.developers_policy.json
}

data "aws_iam_policy_document" "production_policy" {
  statement {
    actions   = ["s3:Get*", "rds:*", "ecs:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_group_policy" "production_policy" {
  name   = "ProductionPolicy"
  group  = aws_iam_group.production.name
  policy = data.aws_iam_policy_document.production_policy.json
}