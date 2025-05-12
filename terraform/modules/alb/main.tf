resource "aws_security_group" "alg_security_group" {
  name = "${var.env}_alb_security_group"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "${var.env}_alb_security_group"
  }
}

resource "aws_lb" "alb" {
  name = "${var.env}-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alg_security_group.id ]
  subnets = var.alb_public_subnets

  tags = {
    Name = "${var.env}-alb"
    Env = "${var.env}"
  }
}

resource "aws_lb_target_group" "alb-target_group" {
  name = "${var.env}-alb-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "instance"

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http_alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb-target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.alb-target_group.arn
  target_id = var.instance_app_id
  port = 8080
}