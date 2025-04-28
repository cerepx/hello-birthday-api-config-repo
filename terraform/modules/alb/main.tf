resource "aws_lb" "this" {
  name               = "hello-birthday-api-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.subnets
}

resource "aws_lb_target_group" "this" {
  name     = "hello-birthday-api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
