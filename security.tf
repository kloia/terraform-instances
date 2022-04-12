
resource "aws_security_group" "sg-lb-to-asg" {
  name        = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode"
  description = "lbtoasg"
  vpc_id      = var.vpc_id

  egress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode-http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode-https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

    ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtonode-mgmt"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
}


resource "aws_security_group" "sg-lb-public" {
  name        = "SG-k8s-${var.cluster_name}-${var.environment}-lbtopublic"
  description = "lbtopublic"
  vpc_id      = var.vpc_id

  egress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtopublic"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtopublic-http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtopublic-https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SG-k8s-${var.cluster_name}-${var.environment}-lbtopublic-mgmt"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
