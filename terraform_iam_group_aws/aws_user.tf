#file for creating user and providing password as output

resource "aws_iam_user" "admin_user" {
    name = "admin"
    tags = {
        description = "admin user for creating other users"
    }
}

resource "aws_iam_user_login_profile" "login_password" {
  user    = aws_iam_user.admin_user.name
}

output "password" {
  value = aws_iam_user_login_profile.login_password
}

resource "aws_iam_policy" "adminuser" {
    name = "administrator"
    policy = data.aws_iam_policy_document.sec-admin.json
}

data "aws_iam_policy_document" "sec-admin" {
  statement {
    effect = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "sec-admin-access" {
    user = aws_iam_user.admin_user.name
    policy_arn = aws_iam_policy.adminuser.arn
}