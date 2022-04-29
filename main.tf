locals {
  point_to_lb     = var.point_to_lb == true ? 1 : 0
  point_to_r53    = var.subdomain != "" && var.point_to_r53 == true && var.point_to_lb == true ? 1 : 0
  fargate_version = "LATEST"

  # convert : demo.example.com to example.com
  root_domain = join(".", slice(split(".", var.subdomain), 1, length(split(".", var.subdomain))))
}

# ------------------------ DATA ------------------------------

data "aws_lb_listener" "https" {
  count = local.point_to_lb
  arn   = var.listener_arn_https
}

data "aws_lb" "lb" {
  count = local.point_to_lb
  arn   = data.aws_lb_listener.https[0].load_balancer_arn
}

# ----------------- ALB TARGET GROUP ------------------------------

resource "aws_lb_target_group" "lb_tg" {
  count = local.point_to_lb
  lifecycle {
    create_before_destroy = true
  }

  name        = "${var.EnvironmentName}-${var.cluster}-${var.service}"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id



  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = var.health_check_matcher
    healthy_threshold   = 3
    unhealthy_threshold = 2
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
    target_group_arn = aws_lb_target_group.lb_tg[0].arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }

  condition {
    host_header {
      values = [var.subdomain == "" ? "*" : var.subdomain]
    }
  }
}


# ----------------- ECS SERVICE ------------------------------

resource "aws_ecs_service" "ecs_service" {

  lifecycle {
    ignore_changes = [desired_count]
  }

  name            = var.service
  cluster         = var.cluster
  task_definition = var.task_definition_arn
  desired_count   = var.min_count

  platform_version                   = local.fargate_version
  force_new_deployment               = var.force_new_deployment
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = 0

  # for stability a 1 dedicated fargate instance and rest spot
  # 1 dedicated per 5 spot
  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 1
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.fargate_spot == true ? toset(["create"]) : toset([])

    content {
      base              = 0
      capacity_provider = "FARGATE_SPOT"
      weight            = 5
    }
  }

  network_configuration {
    subnets          = var.ecs_subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }

  dynamic "load_balancer" {
    for_each = toset(local.point_to_lb == 1 ? ["true"] : [])

    content {
      target_group_arn = aws_lb_target_group.lb_tg[0].arn
      container_name   = var.service
      container_port   = var.container_port
    }
  }

  tags = merge(
    var.tags,
    {
      Name        = var.service,
      Environment = var.EnvironmentName
    }
  )
}

# ----------------- DOMAIN ------------------------------

data "aws_route53_zone" "web" {
  count = local.point_to_r53
  name  = local.root_domain
}

resource "aws_route53_record" "web" {
  count      = local.point_to_r53
  depends_on = [aws_ecs_service.ecs_service]

  zone_id = data.aws_route53_zone.web[0].id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = data.aws_lb.lb[0].dns_name
    zone_id                = data.aws_lb.lb[0].zone_id
    evaluate_target_health = true
  }
}

# ----------------- AUTOSCALING ------------------------------
# ab [options] [http[s]://]hostname[:port]/path
# ab -n 100000 -c 1000 "http://api.output.com:80/"

# cpu base scale

resource "aws_appautoscaling_target" "cpu_scale_up" {
  count      = var.cpu_scale_target > 0 ? 1 : 0
  depends_on = [aws_ecs_service.ecs_service]

  min_capacity       = var.min_count
  max_capacity       = var.scale_max_capacity
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scale_up_policy" {
  count      = var.cpu_scale_target > 0 ? 1 : 0
  depends_on = [aws_appautoscaling_target.cpu_scale_up]

  name               = "ECSServiceAverageCPUUtilization:${aws_appautoscaling_target.cpu_scale_up[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = aws_appautoscaling_target.cpu_scale_up[count.index].scalable_dimension
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_scale_target
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# memory base scale

resource "aws_appautoscaling_target" "memory_scale_up" {
  count      = var.memory_scale_target > 0 ? 1 : 0
  depends_on = [aws_ecs_service.ecs_service]

  min_capacity       = var.min_count
  max_capacity       = var.scale_max_capacity
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "memory_scale_up_policy" {
  count      = var.memory_scale_target > 0 ? 1 : 0
  depends_on = [aws_appautoscaling_target.memory_scale_up]

  name               = "ECSServiceAverageMemoryUtilization:${aws_appautoscaling_target.memory_scale_up[count.index].resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = aws_appautoscaling_target.memory_scale_up[count.index].scalable_dimension
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.memory_scale_target
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# alb based auto scaling

# resource "aws_appautoscaling_target" "scale_up_policy" {
#   min_capacity       = var.min_count
#   max_capacity       = var.scale_max_capacity
#   resource_id        = "service/${var.cluster}/${var.service}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "scale_up_policy" {
#   name               = "ALBRequestCountPerTarget:${aws_appautoscaling_target.scale_up_policy.resource_id}"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = "service/${var.cluster}/${var.service}"
#   scalable_dimension = aws_appautoscaling_target.scale_up_policy.scalable_dimension
#   service_namespace  = "ecs"

#   target_tracking_scaling_policy_configuration {

#     predefined_metric_specification {
#       predefined_metric_type = "ALBRequestCountPerTarget"
#       # app/my-alb/778d41231b141a0f/targetgroup/my-alb-target-group/943f017f100becff
#       resource_label = "${data.aws_lb.lb.arn_suffix}/${aws_lb_target_group.lb_tg.arn_suffix}"
#     }

#     target_value = var.target_value
#     scale_in_cooldown  = var.scale_in_cooldown
#     scale_out_cooldown = var.scale_out_cooldown
#   }
# }
