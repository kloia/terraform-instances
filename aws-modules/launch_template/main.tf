resource "aws_launch_template" "launch_template" {
  name = var.lt_name
  instance_type = var.instance_type
  image_id = var.image_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = var.key_name
  tags = var.default_tags
  user_data = filebase64(var.user_data_path)

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = var.resource_type

    tags = var.resource_tags
  }
}

