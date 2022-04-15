resource "aws_autoscaling_group" "asg" {
  name     = var.asg_name
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_size
  tags = var.default_tags
  wait_for_capacity_timeout = "10m"

  default_cooldown = var.cooldown

  health_check_type = var.healthcheck_type

  launch_template {
    id      = var.launch_template_id
    version = "$Latest" 
    
  }

  target_group_arns = var.target_group_arns

  vpc_zone_identifier = var.vpc_zone_identifier

  lifecycle {
    create_before_destroy = true
  }

  termination_policies = [
    "OldestLaunchConfiguration",
    "NewestInstance"
  ]

  enabled_metrics = [
    "GroupMinSize",
    "GroupDesiredCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupTotalCapacity",
    "GroupPendingCapacity",
    "GroupTerminatingInstances",
    "GroupStandbyInstances",
    "GroupTotalInstances",
    "GroupInServiceCapacity",
    "GroupMaxSize",
    "GroupTerminatingCapacity",
    "GroupInServiceInstances"
  ]
}

output asg_name {
  value = aws_autoscaling_group.asg.name
}
