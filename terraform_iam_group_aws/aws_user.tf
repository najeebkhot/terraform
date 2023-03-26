provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}


resource "aws_iam_user" "admin_user" {
    name = var.users.name
    tags = {
        description = "admin user for creating other users"
    }
}

resource "aws_iam_policy" "adminuser" {
    name = "administrator"
    policy = data.aws_iam_policy_document.admin_admin.arn
}

data "aws_iam_policy_document" "admin_admin" {
  statement {
    effect = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "admin_admin-access" {
    user = aws_iam_user.admin_user.name
    policy = aws_iam_policy.adminuser
}

resource "aws_iam_group" "security" {
  name = "sec_admin"
}

resource "aws_iam_group_membership" "admin_access" {
    name = "admin-access-group-membership"
    users = aws_iam_user.admin_user.name
    group = aws_iam_group.security.name
}

resource "aws_iam_group_policy" "admin_access_team_policy" {
    name  = "my_developer_policy"
    group = aws_iam_group.security.name

    policy = jsonencode({
        Statement = [
        {
            Action = ["iam:*"]
            Effect   = "Allow"
            Resource = "*"
        },
        ]
    })
}

resource "aws_iam_group_policy_attachment" "security_attach" {
  group      = aws_iam_group.security.name
  policy_arn = aws_iam_policy.admin_access_team_policy.arn
}