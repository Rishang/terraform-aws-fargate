output "cluster_name" {
  value = aws_ecs_service.ecs_service.cluster
}
output "service_name" {
  description = "Output ecs service details."
  value       = aws_ecs_service.ecs_service.name
}

output "service_id" {
  description = "Output ecs service details."
  value       = aws_ecs_service.ecs_service.id
}

# output "ecs_task_defination_arn" {
#   value = aws_ecs_service.ecs_service.task_definition
# }

output "service_domain_name" {
  value = join("", aws_route53_record.web[*].name)
}

output "service_domain_id" {
  value = join("", aws_route53_record.web[*].id)
}

output "service_domain_type" {
  value = join("", aws_route53_record.web[*].type)
}
