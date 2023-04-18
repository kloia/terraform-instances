# Provisioning K8s Cluster Instances with Terraform
This Terraform code is designed to provision instances for a **Kubernetes cluster** based on **AWS EC2**. With this code, you can easily provision master and worker nodes, auto-scaling groups, and a load balancer.

### How to Use This Repository
To use this repository, follow these steps:

- Run `terraform init` to initialize Terraform.
- Configure the variables for your environment.
- Run `terraform apply` to provision the infrastructure. If you want to use an external variable file, run terraform apply -var-file=./var.hcl.


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
You can fork the repository and contrib repo via pull-requests . Never hesitate :smiley: