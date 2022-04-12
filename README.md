# Terraform Instances

This terraform code developed for provision `k8s cluster` instances based on `AWS EC2`. You can easily provision master and worker nodes, auto-scaling groups, and load balancer. 

## How to use this repo
- run `terraform init`

- configure variables
- run `terraform apply` (for external variable file `terraform apply -var-file=./var.hcl`)


## Variables


| Variable            | Type   |  Description        |
|---------------------|--------|---------------------|
| cluster_name        | string | k8s cluster name    |
| environment         | string | environment name    |
| region              | string | region              |
| role                | string | user assumed role   |
| ami_id              | string | AMI id              |
| vpc_id              | string | VPC id              |
| subnet_id1          | string | subnet              |
| subnet_id2          | string | alternate subnet    |
| iam_policy          | string | user iam policy     |
| cidr_blocks         | string | cidr blocks         |
| worker_instance_type| string | worker instance type|
| master_instance_type| string | master instance type|
| worker_min_size     | number | worker min size     |
| worker_max_size     | number | worker max size     |
| worker_desired_size | number | worker desired size |
| master_min_size     | number | worker min size     |
| master_max_size     | number | worker max size     |
| master_desired_size | number | worker desired size |
||

## Contribution
You can fork the repository and contrib repo via pull-requests . Never hesitate :smile: