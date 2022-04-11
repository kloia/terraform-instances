locals {
  worker_lt_name                 = "LT-k8s-${var.environment}-Worker"
  master_lt_name                 = "LT-k8s-${var.environment}-Master"
  worker_asg_name                = "ASG-k8s-${var.environment}-Worker"
  master_asg_name                = "ASG-k8s-${var.environment}-Master"
  worker_autoscaling_policy_name = "ASG-Policy-k8s-${var.environment}-Worker"
  private_lb_name                = "ALB-k8s-${var.environment}-private"
  public_lb_name                 = "ALB-k8s-${var.environment}-public"
  tg_lb_http_name                = "tg-k8s-${var.environment}-http-private"
  tg_lb_https_name               = "tg-k8s-${var.environment}-https-private"
  tg_public_lb_http_name         = "tg-k8s-${var.environment}-http-public"
  tg_public_lb_https_name        = "tg-k8s-${var.environment}-https-public"
  sg_name                        = "SG-k8s-${var.environment}-ALBtoNode"
  sg_public_name                 = "SG-k8s-${var.environment}-ALBPublic"
}

resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }

}