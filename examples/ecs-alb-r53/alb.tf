locals {
  alb_name = "${var.EnvironmentName}-${var.alb_name}"
}

# http and https security groups for alb
data "aws_acm_certificate" "amazon_issued" {
  domain      = var.certificate_domain
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# attaching extra certificates to alb
data "aws_acm_certificate" "extra_amazon_issued" {
  # count loop here
  count       = length(var.extra_certificate_domains)
  domain      = var.extra_certificate_domains[count.index]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow ALB inbound HTTP/HTTPS traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "Allow all traffic at 80"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = null
      security_groups  = []
    },
    {
      description      = "Allow all traffic at 443"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = null
      security_groups  = []
    }
  ]

  egress = [
    {
      description      = "egress all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = null,
      security_groups  = []
    }
  ]

  tags = {
    Name = "${var.alb_name}"
  }
}

# ALB

resource "aws_lb" "web" {
  depends_on = [aws_security_group.lb_sg]

  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnets.default.ids

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.bucket
  #   prefix  = "test-lb"
  #   enabled = true
  # }
}

# HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS
resource "aws_lb_listener" "https" {

  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "Direct access is denied"
      status_code  = "401"
    }
  }
}

resource "aws_lb_listener_certificate" "lb_extra_ssl" {
  # count loop here
  count           = length(var.extra_certificate_domains)
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = data.aws_acm_certificate.extra_amazon_issued[count.index].arn
}
