provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}


resource "aws_iam_user" "admin_user" {
    name = "admin"
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