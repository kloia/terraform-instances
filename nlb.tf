resource "aws_lb" "lb-public" {
  name               = "lb-k8s-${var.cluster_name}-${var.environment}"
  depends_on         = [aws_security_group.sg-lb-to-asg]
  load_balancer_type = "network"
  internal           = false
  subnets            = [var.subnet_id1, var.subnet_id2]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "mgmt" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = "6443"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.masters-mgmt.arn
  }
}

resource "aws_lb_listener" "ingress-http" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.workers-http.arn
  }
}

resource "aws_lb_listener" "ingress-https" {
  load_balancer_arn = aws_lb.lb-public.arn
  protocol          = "TCP"
  port              = 443
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.workers-https.arn
  }
}

resource "aws_lb_target_group" "masters-mgmt" {
  name        = "tg-k8s-${var.cluster_name}-masters-mgmt"
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

resource "aws_lb_target_group" "workers-http" {
  name        = "tg-k8s-${var.cluster_name}-workers-http"
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

resource "aws_lb_target_group" "workers-https" {
  name        = "tg-k8s-${var.cluster_name}-workers-https"
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
