data "aws_iam_policy" "ec2policy" {
   name = var.iam_policy
}


module "policy-autoscaler" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "${var.cluster_name}-${var.environment}-autoscaler-policy"
  role_id          = module.role-master.iam_role_id
  role_policy      = "./policies/policy-k8s-autoscaler.json"
}

module "policy-master" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "${var.cluster_name}-${var.environment}-master-policy"
  role_id          = module.role-master.iam_role_id
  role_policy      = "./policies/policy-k8s-master.json"
}

module "policy-worker" {
  source           = "./aws-modules/iam_role_policy"
  role_policy_name = "${var.cluster_name}-${var.environment}-worker-policy"
  role_id          = module.role-worker.iam_role_id
  role_policy      = "./policies/policy-k8s-worker.json"
}

resource "aws_iam_policy_attachment" "ebs-attach-master" {
  name       = "${var.cluster_name}-${var.environment}-master-policy-attachment"
  roles      = [module.role-master.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

resource "aws_iam_policy_attachment" "ebs-attach-worker" {
  name       = "${var.cluster_name}-${var.environment}-worker-policy-attachment"
  roles      = [module.role-worker.iam_role_name]
  policy_arn = data.aws_iam_policy.ec2policy.arn
}

module "role-master" {
  source             = "./aws-modules/iam_role"
  role_name          = "${var.cluster_name}-${var.environment}-master-role"
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

module "role-worker" {
  source             = "./aws-modules/iam_role"
  role_name          = "${var.cluster_name}-${var.environment}-worker-role"
  assume_role_policy = "./policies/ec2-assume-role-policy.json"
}

resource "aws_iam_instance_profile" "profile-worker" {
  name = "${var.cluster_name}-${var.environment}-worker-instance-profile"
  role = module.role-worker.iam_role_name
}

resource "aws_iam_instance_profile" "profile-master" {
  name = "${var.cluster_name}-${var.environment}-master-instance-profile"
  role = module.role-master.iam_role_name
}