variable "iam_user_name" {}

variable "iam_policy_name" {}

variable "policy_json" {}

variable "user_group_name" {
  default = "FGr-AllUsers"
}

variable "accesskeyuser_group_name" {
  default = "FGr-AccessKeyUsers"
}

variable "default_tags" {
  type = map(string)
  default = null
}