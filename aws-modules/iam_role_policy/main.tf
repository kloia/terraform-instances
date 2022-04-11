resource "aws_iam_role_policy" "policy" {
  name = var.role_policy_name
  role = var.role_id

  policy = file(var.role_policy)
}