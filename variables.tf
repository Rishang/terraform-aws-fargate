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

variable "desired_count" {
  type        = number
  description = "Desired count of containers"
  default     = 1
}

variable "security_groups" {
  type        = list(any)
  description = "Extra security groups to attach to ecs service"
  default     = []
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

# ----------------------- Fargate autoscale -------------------------------


variable "scale_min_capacity" {
  type        = number
  description = "Min count of containers"
  default     = 2
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

variable "root_domain" {
  type        = string
  description = "Hosted domain name (HostedZone) eg: example.com"
  default     = ""
}

variable "subdomain" {
  type        = string
  description = "Subdomain name you want to give eg: test.example.com"
  default     = ""
}

variable "point_to_r53" {
  type = bool
  description = "Enable to point to R53"
  default = false
}

# -------------------------------- VPC ---------------------------------

variable "vpc_id" {
  type        = string
  description = "aws vpc id"
  default     = ""
}

variable "ecs_subnets" {
  type        = list(any)
  description = "List of subnets for ecs service"
  default     = []
}

# ------------------------------- ALB -----------------------------------

variable "alb_arn" {
  type        = string
  description = "Application Load Balencer arn"
  default     = ""
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
  description = "HTTPS listner arn for Application Load Balencer"
  default     = ""
}

variable "health_check_path" {
  type        = string
  description = "Health check path for ecs running containers"
  default     = "/"
}

variable "path_pattern" {
  type        = list(any)
  description = "List of paths for alb to route traffic at ecs target group"
  default     = ["/", "/*"]
}


# --------------------- OTHERS ---------------------------------------------

variable "container_port" {
  type    = number
  default = -1
}