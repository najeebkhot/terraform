#File for creating user and providing password as output

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
  value = aws_iam_user_login_profile.login_password.password
}

