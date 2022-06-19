<!-- BEGIN_TF_DOCS -->
# aws ecs fargate terraform module

### Usage

[For examples and refrences click here.](https://github.com/Rishang/terraform-aws-fargate/tree/main/examples)




```terraform

# quick usage look

# things to be created
# ecs service (memory scaling) >> TargetGroup >> Alb HTTPS rule >> Route53 >> app.example.com

module "fargate" {
  source  = "Rishang/fargate/aws"
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
  namespace_id     = aws_service_discovery_private_dns_namespace.service.id

  tags = {
    Name         = "whoami"
    Version      = "latest"
    cluster_name = local.cluster_name
  }
}
```


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.8.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | ecs fargate application cluster name. |
| <a name="output_discovery_arn"></a> [discovery\_arn](#output\_discovery\_arn) | application service discovery name. (if provided) |
| <a name="output_discovery_id"></a> [discovery\_id](#output\_discovery\_id) | application service discovery name. (if provided) |
| <a name="output_discovery_name"></a> [discovery\_name](#output\_discovery\_name) | application service discovery name. (if provided) |
| <a name="output_domain_id"></a> [domain\_id](#output\_domain\_id) | application route53 endpoint id. (if provided) |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | application service domain name. (if provided) |
| <a name="output_domain_type"></a> [domain\_type](#output\_domain\_type) | application route53 endpoint domain type eg. [A, CNAME]. (if provided) |
| <a name="output_id"></a> [id](#output\_id) | ecs fargate application service id. |
| <a name="output_name"></a> [name](#output\_name) | ecs fargate application service name. |

## available tfvar inputs

```hcl
# null are required inputs,
# others are optional default values

EnvironmentName                    = null
assign_public_ip                   = false
cluster                            = null
container_name                     = ""
container_port                     = -1
cpu_scale_target                   = -1
deployment_maximum_percent         = 200
deployment_minimum_healthy_percent = 100
enable_discovery                   = false
fargate_spot                       = false
force_new_deployment               = false
health_check_interval              = 20
health_check_matcher               = "200,202"
health_check_path                  = "/"
lb_scale_target                    = -1
listener_arn_https                 = ""
memory_scale_target                = -1
min_count                          = 1
namespace_id                       = ""
path_pattern                       = ["/", "/*"]
point_to_lb                        = false
point_to_r53                       = false
scale_in_cooldown                  = 250
scale_max_capacity                 = 20
scale_out_cooldown                 = 250
security_groups                    = []
service                            = null
subdomain                          = ""
subnets                            = null
tags                               = {}
task_definition_arn                = null
vpc_id                             = ""
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_EnvironmentName"></a> [EnvironmentName](#input\_EnvironmentName) | The name of the infra environment to deploy to eg. dev, prod, test | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The name of the cluster that hosts the service | `any` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Fargate service name | `any` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets for ecs service | `list(string)` | n/a | yes |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | The ARN of the task definition to use for the ECS service | `string` | n/a | yes |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Auto assign public ip for ecs containers | `bool` | `false` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Required if service name is different than main application container\_name of task defination | `string` | `""` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | container application port | `number` | `-1` | no |
| <a name="input_cpu_scale_target"></a> [cpu\_scale\_target](#input\_cpu\_scale\_target) | Treshold cpu target value for autoscaling ecs service | `number` | `-1` | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Deployment max healthy percent of container count | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Deployment min healthy percent of container count | `number` | `100` | no |
| <a name="input_enable_discovery"></a> [enable\_discovery](#input\_enable\_discovery) | Enable service discovery, requires `namespace_id` and `container_name` | `bool` | `false` | no |
| <a name="input_fargate_spot"></a> [fargate\_spot](#input\_fargate\_spot) | Whether to use fargate spot instances or not. | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Enable to force a new task deployment of the service | `bool` | `false` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | target group health check interval time in sec | `number` | `20` | no |
| <a name="input_health_check_matcher"></a> [health\_check\_matcher](#input\_health\_check\_matcher) | Service health check response matcher | `string` | `"200,202"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Health check path for ecs running containers | `string` | `"/"` | no |
| <a name="input_lb_scale_target"></a> [lb\_scale\_target](#input\_lb\_scale\_target) | Treshold target requests traffic value from alb, for autoscaling ecs service | `number` | `-1` | no |
| <a name="input_listener_arn_https"></a> [listener\_arn\_https](#input\_listener\_arn\_https) | HTTPS listner arn for Application Load Balencer (required if 'point\_to\_lb' is true) | `string` | `""` | no |
| <a name="input_memory_scale_target"></a> [memory\_scale\_target](#input\_memory\_scale\_target) | Treshold memory target value for autoscaling ecs service | `number` | `-1` | no |
| <a name="input_min_count"></a> [min\_count](#input\_min\_count) | Min count of containers | `number` | `1` | no |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | Namespace id (private) for service discovery, Note: discovery endpoint's subdomain will be same as service name | `string` | `""` | no |
| <a name="input_path_pattern"></a> [path\_pattern](#input\_path\_pattern) | List of paths for alb to route traffic at ecs target group | `list(string)` | <pre>[<br>  "/",<br>  "/*"<br>]</pre> | no |
| <a name="input_point_to_lb"></a> [point\_to\_lb](#input\_point\_to\_lb) | Enable to point to ALB (load balancer) | `bool` | `false` | no |
| <a name="input_point_to_r53"></a> [point\_to\_r53](#input\_point\_to\_r53) | Enable to point to R53 | `bool` | `false` | no |
| <a name="input_scale_in_cooldown"></a> [scale\_in\_cooldown](#input\_scale\_in\_cooldown) | The amount of time, in sec, after a scale in activity completes before another scale in activity can start. | `number` | `250` | no |
| <a name="input_scale_max_capacity"></a> [scale\_max\_capacity](#input\_scale\_max\_capacity) | Max count of containers | `number` | `20` | no |
| <a name="input_scale_out_cooldown"></a> [scale\_out\_cooldown](#input\_scale\_out\_cooldown) | The amount of time, in sec, after a scale out activity completes before another scale in activity can start. | `number` | `250` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | Extra security groups to attach to ecs service | `list(string)` | `[]` | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain name you want to give eg: test.example.com (required if 'point\_to\_r53' is true) | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | aws vpc id | `string` | `""` | no |

---
README.md created by: `terraform-docs`
<!-- END_TF_DOCS -->