resource "aws_iam_group" "security" {
    name = "sec-admin"
}

resource "aws_iam_policy" "admin-access-policy" {
    name        = "admin-access-team-policy"
    description = "Provide admin access to IAM"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "iam:*"
            Effect   = "Allow"
            Resource = "*"
        },
        ]
    })
}

resource "aws_iam_group_policy_attachment" "security-attach" {
    group      = aws_iam_group.security.name
    policy_arn = aws_iam_policy.admin-access-policy.arn
}


resource "aws_iam_group_membership" "admin_access" {
    name = "admin-access-group-membership"
    users = [aws_iam_user.admin_user.name]
    group = aws_iam_group.security.name
}