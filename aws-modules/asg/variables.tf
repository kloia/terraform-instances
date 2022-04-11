variable asg_name {}
variable max_size {}
variable min_size {}
variable desired_size {}
variable cooldown { default = "300" }
variable healthcheck_type {}
variable launch_template_id {}
variable vpc_zone_identifier {}
variable target_group_arns {
  #type = map(string)
  default = null
}

variable "default_tags" {
  default = [
    {
      key = "Terraform Project"
      value = "k8s-cluster"
    }
  ]
}