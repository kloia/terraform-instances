resource "aws_iam_user" "iam_user" {
  name = var.iam_user_name
  tags = var.default_tags
}

resource "aws_iam_user_policy" "iam_policy" {
  name = var.iam_policy_name
  user = aws_iam_user.iam_user.name

  policy = var.policy_json
}

resource "aws_iam_user_group_membership" "addUserToAllUsersAccessKeyUsers" {
  user = aws_iam_user.iam_user.name

  groups = [
    var.user_group_name,
    var.accesskeyuser_group_name
  ]
}
