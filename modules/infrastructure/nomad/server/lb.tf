resource "aws_security_group" "web" {
  vpc_id = var.vpc_id
  name   = "port_80"

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "port_80"
  }
}

resource "aws_lb" "nomad" {
  name               = "nomad-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id, aws_security_group.nomad.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "nomad-lb"
  }
}

resource "aws_lb_target_group" "nomad" {
  name        = "nomad-tg"
  port        = 4646
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/v1/agent/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 10
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "nomad" {
  count            = var.server_count
  target_group_arn = aws_lb_target_group.nomad.arn
  target_id        = aws_instance.nomad_servers[count.index].id
  port             = 4646
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.nomad.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nomad.arn
  }
}