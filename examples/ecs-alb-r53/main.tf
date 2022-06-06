locals {
  EnvironmentName = "test"
  cluster_name    = "${local.EnvironmentName}-app"

}

# ------------------------ NERWORK -------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ------------------------ SECURITY -------------------------------

resource "aws_security_group" "ecs_sg" {
  name        = "allow_tls for ecs fargate"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "all traffic allowed as containers will only allow exposed port"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ecs_sg"
  }
}

# ------------------------ ECS ------------------------------------

resource "aws_ecs_cluster" "app" {
  name = local.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "app" {
  cluster_name = aws_ecs_cluster.app.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 2
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

module "fargate_task_definition" {
  source = "github.com/mongodb/terraform-aws-ecs-task-definition"

  family                   = "whoami"
  image                    = "traefik/whoami:latest"
  memory                   = 512
  name                     = "whoami"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  portMappings = [
    {
      containerPort = 80
    },
  ]
}

data "aws_lb_listener" "https" {
  arn = aws_lb_listener.https.arn
}

module "fargate" {
  depends_on = [
    aws_lb.web,
    aws_lb_listener.https
  ]

  source = "../../"

  EnvironmentName = local.EnvironmentName

  # fargate
  cluster             = aws_ecs_cluster.app.name
  service             = "whoami"
  container_port      = 80
  task_definition_arn = module.fargate_task_definition.arn
  min_count           = 2
  fargate_spot        = true

  # networking
  assign_public_ip = true
  vpc_id           = data.aws_vpc.default.id
  subnets          = data.aws_subnets.default.ids
  security_groups  = [aws_security_group.ecs_sg.id]

  # load balancer
  point_to_lb        = true
  listener_arn_https = data.aws_lb_listener.https.arn
  subdomain          = var.subdomain

  # route53
  point_to_r53 = true

  # autoscale
  memory_scale_target = 60
  # cpu_scale_target    = 60


  tags = {
    Name         = "whoami"
    Version      = "1.0.0"
    cluster_name = local.cluster_name
  }
}
