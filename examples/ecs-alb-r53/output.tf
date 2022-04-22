output "vpc" {
  value = data.aws_vpc.default.id
}

output "subnets" {
  value = data.aws_subnets.default.ids
}

output "fargate" {
  value = module.fargate
}