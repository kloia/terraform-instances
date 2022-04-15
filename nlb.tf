data "aws_lb" "lb-private" {
  arn = aws_lb.lb-private.arn
}

data "aws_lb" "lb-public" {
  arn = aws_lb.lb-public.arn
}

resource "aws_lb" "lb-public" {
  name               = "lb-public-${var.cluster_name}-${var.environment}"
  depends_on         = [aws_security_group.sg-lb-to-asg]
  load_balancer_type = "network"
  internal           = false
  subnets            = [var.subnet_id1, var.subnet_id2]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "pub-mgmt" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = "6443"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-master-mgmt.arn
  }
}

resource "aws_lb_listener" "pub-ingress-http" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-worker-http.arn
  }
}

resource "aws_lb_listener" "pub-ingress-https" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = 443
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-worker-https.arn
  }
}

resource "aws_lb_target_group" "pub-master-mgmt" {
  name        = "tg-pub-${var.cluster_name}-${var.environment}-master-mgmt"
  vpc_id      = var.vpc_id
  target_type = "instance"

  protocol = "TCP"
  port     = 6443
  health_check {
    protocol = "TCP"
    port     = 6443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval = 10
  }
}

resource "aws_lb_target_group" "pub-worker-http" {
  name        = "tg-pub-${var.cluster_name}-${var.environment}-worker-http"
  vpc_id      = var.vpc_id
  target_type = "instance"
  protocol = "TCP"
  port     = 80
  health_check {
    protocol = "TCP"
    port     = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval = 10
  }
}

resource "aws_lb_target_group" "pub-worker-https" {
  name        = "tg-pub-${var.cluster_name}-${var.environment}-worker-https"
  vpc_id      = var.vpc_id
  target_type = "instance"
  protocol = "TCP"
  port     = 443
  health_check {
    protocol = "TCP"
    port     = 443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval = 10
  }
}

resource "aws_lb" "lb-private" {
  name               = "lb-priv-${var.cluster_name}-${var.environment}"
  depends_on         = [aws_security_group.sg-lb-to-asg]
  load_balancer_type = "network"
  internal           = false
  subnets            = [var.subnet_id1, var.subnet_id2]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "priv-mgmt" {
  load_balancer_arn = aws_lb.lb-private.arn
  protocol          = "TCP"
  port              = "6443"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.priv-master-mgmt.arn
  }
}

resource "aws_lb_target_group" "priv-master-mgmt" {
  name        = "tg-priv-${var.cluster_name}-${var.environment}-master-mgmt"
  vpc_id      = var.vpc_id
  target_type = "instance"

  protocol = "TCP"
  port     = 6443
  health_check {
    protocol = "TCP"
    port     = 6443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval = 10
  }
}