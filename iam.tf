data "aws_iam_policy" "ec2policy" {
   name = var.iam_policy
}


module "policy-k8s-autoscaler" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "k8s-${var.cluster_name}-${var.environment}-autoscaler-policy"
  role_id          = module.role-k8s-master.iam_role_id
  role_policy      = "./policies/policy-k8s-autoscaler.json"
}

module "policy-k8s-master" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "k8s-${var.cluster_name}-${var.environment}-master-policy"
  role_id          = module.role-k8s-master.iam_role_id
  role_policy      = "./policies/policy-k8s-master.json"
}

module "policy-k8s-worker" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "k8s-${var.cluster_name}-${var.environment}-worker-policy"
  role_id          = module.role-k8s-worker.iam_role_id
  role_policy      = "./policies/policy-k8s-worker.json"
}

resource "aws_iam_policy_attachment" "ebs-attach-master" {
  name       = "k8s-${var.cluster_name}-${var.environment}-master-policy-attachment"
  roles      = [module.role-k8s-master.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

resource "aws_iam_policy_attachment" "ebs-attach-worker" {
  name       = "k8s-${var.cluster_name}-${var.environment}-worker-policy-attachment"
  roles      = [module.role-k8s-worker.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

module "role-k8s-master" {
  source             = "./aws-modules/iam_role"
  role_name          = "k8s-${var.cluster_name}-${var.environment}-master-role"
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

module "role-k8s-worker" {
  source             = "./aws-modules/iam_role"
  role_name          = "k8s-${var.cluster_name}-${var.environment}-worker-role"
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

resource "aws_iam_instance_profile" "profile-k8s-worker" {
  name = "k8s-${var.cluster_name}-${var.environment}-worker-instance-profile"
  role = module.role-k8s-worker.iam_role_name
}

resource "aws_iam_instance_profile" "profile-k8s-master" {
  name = "k8s-${var.cluster_name}-${var.environment}-master-instance-profile"
  role = module.role-k8s-master.iam_role_name
}