resource "aws_lb" "internal_nlb" {
  name               = var.name
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = var.tags
}

resource "aws_lb_listener" "internal_nlb_listener" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_nlb_target_group.arn
  }
}

resource "aws_lb_target_group" "internal_nlb_target_group" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "internal_nlb_attachment" {
  target_group_arn = aws_lb_target_group.internal_nlb_target_group.arn
  target_id        = var.target_id
  port             = var.target_group_port
}
