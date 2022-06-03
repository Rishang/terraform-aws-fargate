output "cluster_name" {
  description = "ecs fargate application cluster name."
  value       = aws_ecs_service.fargate.cluster
}

output "service_name" {
  description = "ecs fargate application service name."
  value       = aws_ecs_service.fargate.name
}

output "service_id" {
  description = "ecs fargate application service id."
  value       = aws_ecs_service.fargate.id
}

output "service_domain_name" {
  description = "application service domain name. (if provided)"
  value       = join("", aws_route53_record.web[*].name)
}

output "service_domain_id" {
  description = "application route53 endpoint id. (if provided)"
  value       = join("", aws_route53_record.web[*].id)
}

output "service_domain_type" {
  description = "application route53 endpoint domain type eg. [A, CNAME]. (if provided)"
  value       = join("", aws_route53_record.web[*].type)
}
