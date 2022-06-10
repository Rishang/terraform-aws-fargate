


```terraform

# quick usage look

# things to be created
# ecs service (memory scaling) >> TargetGroup >> Alb HTTPS rule >> Route53 >> app.example.com

module "fargate" {
  source = "Rishang/fargate/aws"
  version = "1.3.0"

  EnvironmentName = "test"

  # ecs fargate
  cluster             = aws_ecs_cluster.app.name
  service             = "whoami"
  container_port      = 80
  task_definition_arn = module.fargate_task_definition.arn
  min_count           = 3
  fargate_spot        = true

  # networking
  assign_public_ip = true
  vpc_id           = "vpc-demos7"
  subnets          = ["subnet-a2b3","subnet-c9da","subnet-0b23"]
  security_groups  = ["sg-f34d92"]

  # load balancer (optional)
  point_to_lb        = true
  listener_arn_https = aws_lb_listener.https.arn
  subdomain          = "app.example.com"

  # route53 (optional)
  point_to_r53 = true

  # autoscale (optional)
  memory_scale_target = 60
  # cpu_scale_target  = 60

  # service discovery (optional)
  enable_discovery = true
  namespace_id = aws_service_discovery_private_dns_namespace.service.id

  tags = {
    Name         = "whoami"
    Version      = "latest"
    cluster_name = local.cluster_name
  }
}
```
