module "launch_template-master-aws" {
  depends_on             = [aws_security_group.sg-lb-to-asg]
  source                 = "./aws-modules/launch_template"
  lt_name                = local.master_lt_name
  instance_type          = var.master_instance_type
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.sg-lb-to-asg.id]
  key_name               = var.generated_key_name
  iam_instance_profile   = aws_iam_instance_profile.profile-k8s-master.name
  user_data_path         = "./scripts/userdata.sh"
  resource_type          = "instance"
  resource_tags = {
    "Name" : "k8s-${var.environment}-master",
    "k8s.io/cluster-autoscaler/k8s-${var.environment}" : true,
    "k8s.io/cluster-autoscaler/enabled" : true
  }
}

module "launch_template-worker-aws" {
  depends_on             = [aws_security_group.sg-lb-to-asg]
  source                 = "./aws-modules/launch_template"
  lt_name                = local.worker_lt_name
  instance_type          = var.worker_instance_type
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.sg-lb-to-asg.id]
  key_name               = var.generated_key_name
  iam_instance_profile   = aws_iam_instance_profile.profile-k8s-worker.name
  user_data_path         = "./scripts/userdata.sh"
  resource_type          = "instance"
  resource_tags = {
    "Name" : "k8s-${var.environment}-worker",
    "k8s.io/cluster-autoscaler/k8s-${var.environment}" : true,
    "k8s.io/cluster-autoscaler/enabled" : true
  }
}

module "autoscaling_group-worker-aws" {
  depends_on          = [module.launch_template-worker-aws]
  source              = "./aws-modules/asg"
  asg_name            = local.worker_asg_name
  max_size            = var.worker_max_size
  min_size            = var.worker_min_size
  desired_size        = var.worker_desired_size
  healthcheck_type    = "EC2"
  launch_template_id  = module.launch_template-worker-aws.launch_template_id
  vpc_zone_identifier = [var.subnet_id1, var.subnet_id2]
  target_group_arns   = [aws_lb_target_group.lb_target_group-http-aws-private.arn, aws_lb_target_group.lb_target_group-http-aws-public.arn]
  default_tags = concat(
    [
      {
        key                 = "Name"
        value               = "k8s-${var.environment}-worker"
        propagate_at_launch = true
      },
      {
        key                 = "k8s.io/cluster-autoscaler/k8s-${var.environment}"
        value               = true
        propagate_at_launch = true
      },
      {
        key                 = "k8s.io/cluster-autoscaler/enabled"
        value               = true
        propagate_at_launch = true
      }
    ]

  )
}

module "autoscaling_group-master-aws" {
  depends_on          = [module.launch_template-master-aws]
  source              = "./aws-modules/asg"
  asg_name            = local.master_asg_name
  max_size            = var.master_max_size
  min_size            = var.master_min_size
  desired_size        = var.master_desired_size
  healthcheck_type    = "EC2"
  launch_template_id  = module.launch_template-master-aws.launch_template_id
  vpc_zone_identifier = [var.subnet_id1, var.subnet_id2]
  default_tags = concat(
    [
      {
        key                 = "Name"
        value               = "k8s-${var.environment}-master"
        propagate_at_launch = true
      }
    ]
  )
}