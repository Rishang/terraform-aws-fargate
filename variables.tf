variable "cluster" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "service" {
  type        = string
  description = "Name of the ECS service"
}

variable "task_definition_arn" {
  type        = string
  description = "ARN of the task definition to use for the service"
}

variable "min_count" {
  type        = number
  description = "Minimum number of tasks to run for the service"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the service should be launched"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs where the service should be launched"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs to assign to the tasks"
}

variable "container_port" {
  type        = number
  description = "Port number that the container listens on"
}

variable "path_pattern" {
  type        = list(string)
  description = "List of path patterns to match in the ALB rules"
}

variable "listener_arn_https" {
  type        = string
  description = "ARN of the HTTPS listener for the ALB"
}

variable "point_to_lb" {
  type        = bool
  description = "Whether to associate the service with an ALB"
  default     = false
}

variable "point_to_r53" {
  type        = bool
  description = "Whether to create a DNS record for the service"
  default     = false
}

variable "subdomain" {
  type        = string
  description = "Subdomain to use in the DNS record"
  default     = ""
}

variable "health_check_interval" {
  type        = number
  description = "Interval in seconds between health checks"
  default     = 30
}

variable "health_check_path" {
  type        = string
  description = "Path to check for the health check"
  default     = "/"
}

variable "health_check_matcher" {
  type        = string
  description = "String to look for in the response to the health check"
  default     = "200 OK"
}

variable "failure_threshold" {
  type        = number
  description = "Number of consecutive health check failures before the target is considered unhealthy"
  default     = 2
}

variable "enable_discovery" {
  type        = bool
  description = "Whether to enable service discovery for the service"
  default     = false
}

variable "namespace_id" {
  type        = string
  description = "ID of the service discovery namespace to use"
}

variable "container_name" {
  type        = string
  description = "Name of the container to use for service discovery"
  default     = ""
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP address to the task"
  default     = false
}

variable "force_new_deployment" {
  type        = bool
  description = "Whether to force a new deployment when updating the service"
  default     = false
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Minimum percentage of healthy tasks during a deployment"
  default     = 100
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Maximum percentage of tasks to launch during a deployment"
  default     = ""
}
