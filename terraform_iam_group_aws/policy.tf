#Creating IAM Admin Policy

resource "aws_iam_policy" "admin-policy" {
    name = "administrator"
    policy = data.aws_iam_policy_document.sec-admin-permission.json
}

#This policy allows all IAM action to the user/group
data "aws_iam_policy_document" "sec-admin-permission" {
  statement {
    effect = "Allow"
    actions   = ["iam:*"]
    resources = ["*"]
  }
}

#Attaching the policy to the group/user
resource "aws_iam_user_policy_attachment" "sec-admin-access" {
    user = aws_iam_user.admin_user.name
    policy_arn = aws_iam_policy.admin-policy.arn
}
