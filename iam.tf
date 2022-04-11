locals {
  master_policy_name            = "master-k8s-${var.environment}-policy"
  worker_policy_name            = "worker-k8s-${var.environment}-policy"
  autoscaler_policy_name        = "autoscaler-k8s-${var.environment}-policy"
  master_role_name              = "master-k8s-${var.environment}-role"
  worker_role_name              = "worker-k8s-${var.environment}-role"
  worker_policy_attachment_name = "worker-k8s-${var.environment}-policy-attachment"
  master_policy_attachment_name = "master-k8s-${var.environment}-policy-attachment"
  worker_instance_profile_name  = "worker-k8s-${var.environment}-instance-profile"
  master_instance_profile_name  = "master-k8s-${var.environment}-instance-profile"
}

data "aws_iam_policy" "ec2policy" {
   name = var.iam_policy
}


module "policy-k8s-autoscaler" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = local.autoscaler_policy_name
  role_id          = module.role-k8s-master.iam_role_id
  role_policy      = "./policies/policy-k8s-autoscaler.json"
}

module "policy-k8s-master" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = local.master_policy_name
  role_id          = module.role-k8s-master.iam_role_id
  role_policy      = "./policies/policy-k8s-master.json"
}

module "policy-k8s-worker" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = local.worker_policy_name
  role_id          = module.role-k8s-worker.iam_role_id
  role_policy      = "./policies/policy-k8s-worker.json"
}

resource "aws_iam_policy_attachment" "ebs-attach-master" {
  name       = local.master_policy_attachment_name
  roles      = [module.role-k8s-master.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

resource "aws_iam_policy_attachment" "ebs-attach-worker" {
  name       = local.worker_policy_attachment_name
  roles      = [module.role-k8s-worker.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

module "role-k8s-master" {
  source             = "./aws-modules/iam_role"
  role_name          = local.master_role_name
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

module "role-k8s-worker" {
  source             = "./aws-modules/iam_role"
  role_name          = local.worker_role_name
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

resource "aws_iam_instance_profile" "profile-k8s-worker" {
  name = local.worker_instance_profile_name
  role = module.role-k8s-worker.iam_role_name
}

resource "aws_iam_instance_profile" "profile-k8s-master" {
  name = local.master_instance_profile_name
  role = module.role-k8s-master.iam_role_name
}