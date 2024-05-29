


```terraform

# quick usage look

# things to be created
# ecs service (memory scaling) >> TargetGroup >> Alb HTTPS rule >> Route53 >> app.example.com

module "fargate" {
  source  = "Rishang/fargate/aws"
  version = "1.4.3"

  EnvironmentName = "test"

  # ecs fargate
  cluster             = aws_ecs_cluster.app.name
  service             = "whoami"
  container_port      = 80
  task_definition_arn = module.fargate_task_definition.arn
  scale_min_capacity  = 3
  scale_max_capacity  = 10
  
  # keep 1 FARGATE for each 5 FARGATE_SPOT
  capacity_provider_strategy = [
    {
      base              = 1
      capacity_provider = "FARGATE"
      weight            = 1
    },
    {
      base              = 0
      capacity_provider = "FARGATE_SPOT"
      weight            = 5
    }
  ]

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
  create_autoscale_target = true
  cpu_scale_target  = 60
  # memory_scale_target = 60

  # scheduled scaling (optional)
  scaling_schedule = [
    {
      # Scale count to zero every night at 19:00
      schedule     = "cron(0 19 * * ? *)"
      min_capacity = 0
      max_capacity = 0
    },
    {
      # Scale count to 3 every morning at 7:00
      schedule     = "cron(0 7 * * ? *)"
      min_capacity = 3
      max_capacity = 10 
    }
  ]

  # service discovery (optional)
  enable_discovery = true
  namespace_id     = aws_service_discovery_private_dns_namespace.service.id

  tags = {
    Name         = "whoami"
    Version      = "latest"
    cluster_name = local.cluster_name
  }
}
```
