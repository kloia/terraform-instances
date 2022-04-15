data "aws_instances" "masters" {
  depends_on = [
    module.autoscaling_group-master-aws
  ]
  instance_tags = {
    Name = "${var.cluster_name}-${var.environment}-master"
  }
}

data "aws_instances" "workers" {
  depends_on = [
    module.autoscaling_group-worker-aws
  ]
  instance_tags = {
    Name = "${var.cluster_name}-${var.environment}-worker"
  }
}

module "launch_template-master-aws" {
  depends_on             = [aws_security_group.sg-lb-to-asg]
  source                 = "./aws-modules/launch_template"
  lt_name                = "lt-${var.cluster_name}-${var.environment}-master"
  instance_type          = var.master_instance_type
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.sg-lb-to-asg.id]
  key_name               = "${var.cluster_name}-${var.environment}-key"
  iam_instance_profile   = aws_iam_instance_profile.profile-master.name
  user_data_path         = "./scripts/userdata.sh"
  resource_type          = "instance"
  resource_tags = {
    "Name" : "${var.environment}-master",
    "k8s.io/cluster-autoscaler/${var.environment}" : true,
    "k8s.io/cluster-autoscaler/enabled" : true
  }
}

module "launch_template-worker-aws" {
  depends_on             = [aws_security_group.sg-lb-to-asg]
  source                 = "./aws-modules/launch_template"
  lt_name                = "lt-${var.cluster_name}-${var.environment}-worker"
  instance_type          = var.worker_instance_type
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.sg-lb-to-asg.id]
  key_name               = "${var.cluster_name}-${var.environment}-key"
  iam_instance_profile   = aws_iam_instance_profile.profile-worker.name
  user_data_path         = "./scripts/userdata.sh"
  resource_type          = "instance"
  resource_tags = {
    "Name" : "${var.cluster_name}-${var.environment}-worker",
    "k8s.io/cluster-autoscaler/${var.environment}" : true,
    "k8s.io/cluster-autoscaler/enabled" : true
  }
}

module "autoscaling_group-worker-aws" {
  depends_on          = [module.launch_template-worker-aws,aws_key_pair.generated_key]
  source              = "./aws-modules/asg"
  asg_name            = "asg-${var.cluster_name}-${var.environment}-worker"
  max_size            = var.worker_max_size
  min_size            = var.worker_min_size
  desired_size        = var.worker_desired_size
  healthcheck_type    = "EC2"
  launch_template_id  = module.launch_template-worker-aws.launch_template_id
  vpc_zone_identifier = [var.subnet_id1, var.subnet_id2]
  target_group_arns   = [aws_lb_target_group.pub-worker-https.arn, aws_lb_target_group.pub-worker-http.arn]
  default_tags = concat(
    [
      {
        key                 = "Name"
        value               = "${var.cluster_name}-${var.environment}-worker"
        propagate_at_launch = true
      },
      {
        key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}-${var.environment}"
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
  depends_on          = [module.launch_template-master-aws,aws_key_pair.generated_key]
  source              = "./aws-modules/asg"
  asg_name            = "asg-${var.cluster_name}-${var.environment}-master"
  max_size            = var.master_max_size
  min_size            = var.master_min_size
  desired_size        = var.master_desired_size
  healthcheck_type    = "EC2"
  launch_template_id  = module.launch_template-master-aws.launch_template_id
  vpc_zone_identifier = [var.subnet_id1, var.subnet_id2]
  target_group_arns   = [aws_lb_target_group.pub-master-mgmt.arn,aws_lb_target_group.priv-master-mgmt.arn]
  default_tags = concat(
    [
      {
        key                 = "Name"
        value               = "${var.cluster_name}-${var.environment}-master"
        propagate_at_launch = true
      }
    ]
  )
}