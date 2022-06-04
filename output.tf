output "cluster_name" {
  description = "ecs fargate application cluster name."
  value       = aws_ecs_service.fargate.cluster
}

output "name" {
  description = "ecs fargate application service name."
  value       = aws_ecs_service.fargate.name
}

output "id" {
  description = "ecs fargate application service id."
  value       = aws_ecs_service.fargate.id
}

output "domain_name" {
  description = "application service domain name. (if provided)"
  value       = join("", aws_route53_record.web[*].name)
}

output "domain_id" {
  description = "application route53 endpoint id. (if provided)"
  value       = join("", aws_route53_record.web[*].id)
}

output "domain_type" {
  description = "application route53 endpoint domain type eg. [A, CNAME]. (if provided)"
  value       = join("", aws_route53_record.web[*].type)
}

output "discovery_name" {
  description = "application service discovery name. (if provided)"
  value       = join("", aws_service_discovery_service.fargate[*].name)
}

output "discovery_arn" {
  description = "application service discovery name. (if provided)"
  value       = join("", aws_service_discovery_service.fargate[*].arn)
}

output "discovery_id" {
  description = "application service discovery name. (if provided)"
  value       = join("", aws_service_discovery_service.fargate[*].id)
}
