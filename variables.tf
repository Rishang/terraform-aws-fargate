# ----- Environment ---------------

variable "EnvironmentName" {
  type        = string
  description = "The name of the infra environment to deploy to eg. dev, prod, test"
}

variable "tags" {
  type        = map(any)
  description = "Tags to apply to the resources"
  default     = {}
}

# ----------------------------  ECS Fargate --------------------------------

variable "task_definition_arn" {
  type        = string
  description = "The ARN of the task definition to use for the ECS service"
}

variable "cluster" {
  description = "The name of the cluster that hosts the service"
}

variable "service" {
  description = "Fargate service name"
}

variable "assign_public_ip" {
  type        = bool
  description = "Auto assign public ip for ecs containers"
  default     = false
}

variable "force_new_deployment" {
  type        = bool
  description = "Enable to force a new task deployment of the service"
  default     = false
}

variable "security_groups" {
  type        = list(string)
  description = "Extra security groups to attach to ecs service"
  default     = []
}

variable "enable_ecs_managed_tags" {
  type        = bool
  description = "Specifies whether to enable Amazon ECS managed tags for the service."
  default     = false
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Deployment min healthy percent of container count"
  default     = 100
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Deployment max healthy percent of container count"
  default     = 200
}

variable "capacity_provider_strategy" {
  type        = list(map(any))
  description = "Capacity provider strategy for ecs service here `base` parameter defines the minimum number of tasks that should be launched using the specified capacity provider before considering the weight. `weight` parameter defines the relative percentage of tasks to be launched using the specified capacity provider after the base tasks have been satisfied."
  default = [
    {
      base              = 1
      capacity_provider = "FARGATE"
      weight            = 1
    },
    {
      base              = 0
      capacity_provider = "FARGATE_SPOT"
      weight            = 0
    }
  ]
}

# ----------------------- Fargate autoscale -------------------------------

variable "create_autoscale_target" {
  type        = bool
  description = "Enable to create autoscale for ecs service"
  default     = false
}

variable "scale_min_capacity" {
  type        = number
  description = "Min count of containers"
  default     = 1
}

variable "scale_max_capacity" {
  type        = number
  description = "Max count of containers"
  default     = 20
}

variable "cpu_scale_target" {
  type        = number
  description = "Treshold cpu target value for autoscaling ecs service"
  default     = -1
}

variable "memory_scale_target" {
  type        = number
  description = "Treshold memory target value for autoscaling ecs service"
  default     = -1
}

variable "lb_scale_target" {
  type        = number
  description = "Treshold target requests traffic value from alb, for autoscaling ecs service"
  default     = -1
}

variable "scale_in_cooldown" {
  type        = number
  description = "The amount of time, in sec, after a scale in activity completes before another scale in activity can start."
  default     = 250
}

variable "scale_out_cooldown" {
  type        = number
  description = "The amount of time, in sec, after a scale out activity completes before another scale in activity can start."
  default     = 250
}


# ----------------------- ROUTE 53 ----------------------------------------

variable "point_to_r53" {
  type        = bool
  description = "Enable to point to R53"
  default     = false
}

variable "subdomain" {
  type        = string
  description = "Subdomain name you want to give eg: test.example.com (required if 'point_to_r53' is true)"
  default     = ""
}

# -------------------------------- VPC ---------------------------------

variable "vpc_id" {
  type        = string
  description = "aws vpc id"
  default     = ""
}

variable "subnets" {
  type        = list(string)
  description = "List of subnets for ecs service"
}

# ------------------------------- ALB -----------------------------------

variable "point_to_lb" {
  type        = bool
  description = "Enable to point to ALB (load balancer)"
  default     = false
}

variable "health_check_matcher" {
  type        = string
  description = "Service health check response matcher"
  default     = "200,202"
}

variable "health_check_interval" {
  type        = number
  description = "target group health check interval time in sec"
  default     = 20
}

variable "listener_arn_https" {
  type        = string
  description = "HTTPS listner arn for Application Load Balencer (required if 'point_to_lb' is true)"
  default     = ""
}

variable "health_check_path" {
  type        = string
  description = "Health check path for ecs running containers"
  default     = "/"
}

variable "path_pattern" {
  type        = list(string)
  description = "List of paths for alb to route traffic at ecs target group"
  default     = ["/", "/*"]
}

# --------------------- SERVICE DISCOVERY ---------------------------------

variable "enable_discovery" {
  type        = bool
  description = "Enable service discovery, requires `namespace_id` and `container_name`"
  default     = false
}

variable "namespace_id" {
  type        = string
  description = "Namespace id (private) for service discovery, Note: discovery endpoint's subdomain will be same as service name"
  default     = ""
}

# --------------------- OTHERS ---------------------------------------------

variable "container_port" {
  type        = number
  description = "container application port"
  default     = -1
}

variable "container_name" {
  type        = string
  description = "Required if service name is different than main application container_name of task defination"
  default     = ""
}

variable "scaling_schedule" {
  type        = list(any)
  default     = []
  description = "Schedule scaling for ecs service [{\"schedule\":\"cron(0 3 * * ? *)\", \"min_capacity\": 1, \"max_capacity\": 1}]"
}
