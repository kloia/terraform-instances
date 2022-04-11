variable lt_name {}
variable instance_type {}
variable image_id {}
variable vpc_security_group_ids {}
variable key_name {}
variable user_data_path {}
variable iam_instance_profile {}
variable resource_type {}
variable resource_tags {
  type = map(string)
  default = null
}
variable "default_tags" {
  type = map(string)
  default = null
}