variable "cluster_name" {
  default = "test"
}

variable "environment" {
  default = "test"
}

variable "region" {
  default = "eu-west-1"
}

variable "role" {
  default = "arn:aws:iam::417732881703:role/eks-admin"
}

variable "ami_id" {
  default = "ami-08ca3fed11864d6bb"
}

variable "vpc_id" {
  default = "vpc-024f3e66"
}

variable "worker_instance_type" {
  default = "t2.micro"
}

variable "master_instance_type" {
  default = "t2.micro"
}

variable "subnet_id1" {
  default = "subnet-ec04449a"
}

variable "subnet_id2" {
  default = "subnet-f9b3fb9d"
}

variable "iam_policy" {
  default = "eks-all"
}

variable "cidr_blocks" {
  default = ["172.31.0.0/16"]
}

variable "worker_min_size" {
  default = 2
}

variable "worker_max_size" {
  default = 2
}

variable "worker_desired_size" {
  default = 2
}

variable "master_min_size" {
  default = 1
}

variable "master_max_size" {
  default = 1
}

variable "master_desired_size" {
  default = 1
}