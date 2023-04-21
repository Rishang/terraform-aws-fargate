output "service_name" {
  value       = aws_ecs_service.fargate.name
  description = "Name of the ECS service"
}

output "service_arn" {
  value       = aws_ecs_service.fargate.arn
  description = "ARN of the ECS service"
}

output "task_definition_arn" {
  value       = aws_ecs_service.fargate.task_definition
  description = "ARN of the task definition used by the service"
}

output "load_balancer_dns_name" {
  value       = data.aws_lb.lb.dns_name
  description = "DNS name of the ALB associated with the service"
}

output "scaling_policy_arn_cpu" {
  value       = aws_appautoscaling_policy.cpu_scale_up_policy.arn
  description = "ARN of the scaling policy for CPU usage"
}

output "scaling_policy_arn_memory" {
  value       = aws_appautoscaling_policy.memory_scale_up_policy.arn
  description = "ARN of the scaling policy for memory usage"
}

output "scaling_policy_arn_lb" {
  value       = aws_appautoscaling_policy.scale_up_policy.arn
  description = "ARN of the scaling policy for ALB requests"
}
