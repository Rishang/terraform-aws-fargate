locals {
  point_to_lb     = var.point_to_lb ? 1 : 0
  point_to_r53    = var.subdomain != "" && var.point_to_r53 && var.point_to_lb ? 1 : 0
  fargate_version = "LATEST"

  failure_threshold = 2

  enable_discovery = var.enable_discovery ? 1 : 0
  container_name   = var.container_name != "" ? var.container_name : var.service

  # Convert "demo.example.com" to "example.com"
  root_domain = replace(var.subdomain, "^.*?\\.", "")
}

# ------------------------ DATA ------------------------------

data "aws_lb_listener" "https" {
  count = local.point_to_lb
  arn   = var.listener_arn_https

  depends_on = [
    aws_lb_target_group.lb_tg,
  ]
}

data "aws_lb" "lb" {
  count = local.point_to_lb
  arn   = data.aws_lb_listener.https[0].load_balancer_arn

  depends_on = [
    aws_lb_target_group.lb_tg,
  ]
}

# ----------------- ALB TARGET GROUP ------------------------------

resource "aws_lb_target_group" "lb_tg" {
  count = local.point_to_lb

  name        = "${var.cluster}-${var.service}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = var.health_check_matcher
    healthy_threshold   = 3
    unhealthy_threshold = local.failure_threshold
    timeout             = 10
  }

  tags = {
    Environment = var.EnvironmentName
    Service     = var.service
  }
}


# ----------------- ALB RULES ------------------------------

resource "aws_lb_listener_rule" "https" {
  count = local.point_to_lb

  listener_arn = var.listener_arn_https

  lifecycle {
    create_before_destroy = true
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg[count.index].arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }

  dynamic "condition" {
    for_each = local.point_to_r53 ? ["create"] : []

    content {
      host_header {
        values = [var.subdomain]
      }
    }
  }
}


# ----------------- SERVICE DISCOVERY ---------------------

resource "aws_service_discovery_service" "fargate" {
  count = local.enable_discovery

  name          = var.service
  description   = "Discovery for service: ${var.service} for cluster: ${var.cluster}"
  force_destroy = true

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = local.failure_threshold
  }

  tags = var.tags
}

# ----------------- ECS SERVICE ------------------------------

resource "aws_ecs_service" "fargate" {
  name            = var.service
  cluster         = var.cluster
  task_definition = var.task_definition_arn
  desired_count   = var.min_count

  platform_version     = local.fargate_version
  force_new_deployment = var.force_new_deployment

}
