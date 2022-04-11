
resource "aws_lb" "lb-cluster-private" {
  depends_on                 = [aws_security_group.sg-lb-to-asg]
  name                       = local.private_lb_name
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg-lb-to-asg.id] 
  subnets                    = [var.subnet_id1, var.subnet_id2]
  enable_deletion_protection = true

  tags = {
    Environment = "aws-${var.environment}"
  }
}

resource "aws_lb_listener" "lb_listener-http-aws-private" {
  load_balancer_arn = aws_lb.lb-cluster-private.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group-http-aws-private.arn
  }
}

resource "aws_lb_listener" "lb_listener-https-aws-private" {
  load_balancer_arn = aws_lb.lb-cluster-private.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group-https-aws-private.arn
  }
}

resource "aws_lb_target_group" "lb_target_group-http-aws-private" {
  name     = local.tg_lb_http_name
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    path    = "/healthz"
  }
}

resource "aws_lb_target_group" "lb_target_group-https-aws-private" {
  name     = local.tg_lb_https_name
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    path    = "/healthz"
  }
}

resource "aws_security_group" "sg-lb-to-asg" {
  name        = local.sg_name
  description = "lbtoK8SNodes"
  vpc_id      = var.vpc_id

  egress {
    description = local.sg_name
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = local.sg_name
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = local.sg_name
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = local.sg_name
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  ingress {
    description = local.sg_name
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  ingress {
    description = local.sg_name
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

    ingress {
    description = local.sg_name
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }
}




resource "aws_lb" "lb-cluster-public" {
  depends_on                 = [aws_security_group.sg-lb-to-asg]
  name                       = local.public_lb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg-lb-to-asg.id, aws_security_group.sg-lb-public.id]
  subnets                    = [var.subnet_id1, var.subnet_id2]                                                   
  enable_deletion_protection = true

  tags = {
    Environment = "aws-${var.environment}"
  }
}

resource "aws_lb_listener" "lb_listener-http-aws-public" {
  load_balancer_arn = aws_lb.lb-cluster-public.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group-http-aws-public.arn
  }
}

resource "aws_lb_listener" "lb_listener-https-aws-public" {
  load_balancer_arn = aws_lb.lb-cluster-public.arn
  port              = 443
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group-https-aws-public.arn
  }
}

resource "aws_lb_target_group" "lb_target_group-http-aws-public" {
  name     = local.tg_public_lb_http_name
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    path    = "/healthz"
  }
}

resource "aws_lb_target_group" "lb_target_group-https-aws-public" {
  name     = local.tg_public_lb_https_name
  port     = 443
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    enabled = true
    path    = "/healthz"
  }
}

resource "aws_security_group" "sg-lb-public" {
  name        = local.sg_public_name
  description = "http https traffic"
  vpc_id      = var.vpc_id

  egress {
    description = local.sg_public_name
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = local.sg_public_name
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = local.sg_public_name
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = local.sg_public_name
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_lb_listener" "lb_listener-mgmt-aws-public" {
#   load_balancer_arn = aws_lb.lb-cluster-public.arn
#   port              = 6443
#   protocol          = "TCP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group-mgmt-aws-public.arn
#   }
# }

# resource "aws_lb_target_group" "lb_target_group-mgmt-aws-public" {
#   name     = local.tg_public_lb_name
#   port     = 6443
#   protocol = "TCP"
#   vpc_id   = var.vpc_id
#   health_check {
#     enabled = true
#     protocol = "TCP"
#     port     = 6443
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     interval = 10
#   }
# }

# resource "aws_lb_listener" "lb_listener-mgmt-aws-private" {
#   load_balancer_arn = aws_lb.lb-cluster-private.arn
#   port              = 6443
#   protocol          = "TCP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.lb_target_group-mgmt-aws-private.arn
#   }
# }

# resource "aws_lb_target_group" "lb_target_group-mgmt-aws-private" {
#   name     = local.tg_lb_name
#   port     = 6443
#   protocol = "TCP"
#   vpc_id   = var.vpc_id
#   health_check {
#     enabled = true
#     protocol = "TCP"
#     port     = 6443
#     healthy_threshold   = 3
#     unhealthy_threshold = 3
#     interval = 10
#   }
# }