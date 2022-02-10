# ----- EnvironmentName ---------------

variable "EnvironmentName" {
  type        = string
  description = "The name of the infra environment to deploy to"
}


# ----- TAKS-DEFINATION-VARS -----------

# Container definitions are used in task definitions to describe the different containers that are launched as part of a task.
# https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html

variable "command" {
  default     = []
  description = "The command that is passed to the container"
  type        = list(string)
}

variable "cpu" {
  default     = 256
  description = "The number of cpu units reserved for the container"
  type        = number
}

variable "disableNetworking" {
  default     = false
  description = "When this parameter is true, networking is disabled within the container"
}

variable "dnsSearchDomains" {
  default     = []
  description = "A list of DNS search domains that are presented to the container"
  type        = list(string)
}

variable "dnsServers" {
  default     = []
  description = "A list of DNS servers that are presented to the container"
  type        = list(string)
}

variable "dockerLabels" {
  default     = {}
  description = "A key/value map of labels to add to the container"
  type        = map(string)
}

variable "dockerSecurityOptions" {
  default     = []
  description = "A list of strings to provide custom labels for SELinux and AppArmor multi-level security systems"
  type        = list(string)
}

variable "entryPoint" {
  default     = []
  description = "The entry point that is passed to the container"
  type        = list(string)
}

variable "environment" {
  default     = []
  description = "The environment variables to pass to a container"
  type        = list(map(string))
}

variable "essential" {
  default     = true
  description = "If the essential parameter of a container is marked as true, and that container fails or stops for any reason, all other containers that are part of the task are stopped"
}

variable "execution_role_arn" {
  default     = ""
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
}

variable "extraHosts" {
  default     = []
  description = "A list of hostnames and IP address mappings to append to the /etc/hosts file on the container"

  type = list(object({
    ipAddress = string
    hostname  = string
  }))
}

variable "healthCheck" {
  default     = {}
  description = "The health check command and associated configuration parameters for the container"
  type        = any
}

variable "hostname" {
  default     = ""
  description = "The hostname to use for your container"
}

variable "image" {
  default     = ""
  description = "The image used to start a container"
}

variable "interactive" {
  default     = false
  description = "When this parameter is true, this allows you to deploy containerized applications that require stdin or a tty to be allocated"
}

variable "ipc_mode" {
  default     = null
  description = "The IPC resource namespace to use for the containers in the task"
}

variable "links" {
  default     = []
  description = "The link parameter allows containers to communicate with each other without the need for port mappings"
  type        = list(string)
}

variable "linuxParameters" {
  default     = {}
  description = "Linux-specific modifications that are applied to the container, such as Linux KernelCapabilities"
  type        = any
}

variable "logConfiguration" {
  default     = {}
  description = "The log configuration specification for the container"
  type        = any
}

variable "memory" {
  default     = 512
  description = "The hard limit (in MiB) of memory to present to the container"
  type        = number
}

variable "memoryReservation" {
  default     = 0
  description = "The soft limit (in MiB) of memory to reserve for the container"
}

variable "mountPoints" {
  default     = []
  description = "The mount points for data volumes in your container"
  type        = list(any)
}

variable "name" {
  default     = ""
  description = "The name of a container"
}

variable "network_mode" {
  default     = "bridge"
  description = "The Docker networking mode to use for the containers in the task"
}

variable "pid_mode" {
  default     = null
  description = "The process namespace to use for the containers in the task"
}

variable "placement_constraints" {
  default     = []
  description = "An array of placement constraint objects to use for the task"
  type = list(object({
    type       = string
    expression = string
  }))
}

# variable "portMappings" {
#   default     = []
#   description = "The list of port mappings for the container"
#   type        = list(string)
# }

variable "container_port" {
  description = "The list of port mappings for the container"
  type        = number
}

variable "privileged" {
  default     = false
  description = "When this parameter is true, the container is given elevated privileges on the host container instance (similar to the root user)"
}

variable "pseudoTerminal" {
  default     = false
  description = "When this parameter is true, a TTY is allocated"
}

variable "readonlyRootFilesystem" {
  default     = false
  description = "When this parameter is true, the container is given read-only access to its root file system"
}

variable "repositoryCredentials" {
  default     = {}
  description = "The private repository authentication credentials to use"
  type        = map(string)
}

variable "requires_compatibilities" {
  default     = []
  description = "The launch type required by the task"
  type        = list(string)
}

variable "resourceRequirements" {
  default     = []
  description = "The type and amount of a resource to assign to a container"
  type        = list(string)
}

variable "secrets" {
  default     = []
  description = "The secrets to pass to the container"
  type        = list(map(string))
}

variable "systemControls" {
  default     = []
  description = "A list of namespaced kernel parameters to set in the container"
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}

variable "task_role_arn" {
  default     = ""
  description = "The short name or full Amazon Resource Name (ARN) of the IAM role that containers in this task can assume"
}

variable "ulimits" {
  default     = []
  description = "A list of ulimits to set in the container"
  type        = list(any)
}

variable "user" {
  default     = ""
  description = "The user name to use inside the container"
}

variable "volumes" {
  default     = []
  description = "A list of volume definitions in JSON format that containers in your task may use"
  type        = list(any)
}

variable "volumesFrom" {
  default     = []
  description = "Data volumes to mount from another container"

  type = list(object({
    readOnly        = bool
    sourceContainer = string
  }))
}

variable "workingDirectory" {
  default     = ""
  description = "The working directory in which to run commands inside the container"
}


# ----------------------------  ECS Fargate --------------------------------

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

variable "is_cpu_scale" {
  type        = bool
  description = "(optional) to set cpu scaling"
  default     = false
}

variable "is_memory_scale" {
  type        = bool
  description = "(optional) to set memory scaling"
  default     = false
}

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

variable "cpu_target_value" {
  type        = number
  description = "Treshold cpu target value for autoscaling ecs service"
  default     = 70
}

variable "memory_target_value" {
  type        = number
  description = "Treshold memory target value for autoscaling ecs service"
  default     = 70
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


# ROUTE 53

variable "create_subdomain" {
  type        = bool
  default     = false
  description = "true, to create subdomain for the resource | false, if not"
}

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

variable "health_check_interval" {
  type        = number
  description = "target group health check interval time in sec"
  default     = 20
}

variable "https_listener" {
  type        = bool
  description = "true to set rule for alb https listener rule | false for http"
  default     = true
}

variable "listener_arn_http" {
  type        = string
  description = "HTTP listner arn for Application Load Balencer"
  default     = ""
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
