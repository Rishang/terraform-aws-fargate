# Applies to every targets in the file! https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:

TF_PROVIDER_FILE = https://gist.githubusercontent.com/th-rishang/ec62a89a9e77debe3b533ccaf0a1a613/raw/98469e2c06d4d04525cd14ff0b435d7821b3f103/localstack_terraform_conf.tf
lint:
	terraform validate

# https://github.com/im2nguyen/rover
graph:
	rover -tfPath `which terraform` -genImage

fmt:
	terraform fmt -recursive

# tools url:
# https://github.com/shihanng/tfvar
# https://github.com/terraform-docs/terraform-docs
docs:
	tfvar . > vars/example.tfvars
	terraform-docs .

# https://docs.localstack.cloud/overview/
set-local:
	curl -o examples/ecs/localstack_aws_provider.tf $(TF_PROVIDER_FILE)
	curl -o examples/ecs-alb-r53/localstack_aws_provider.tf $(TF_PROVIDER_FILE)
	curl -o examples/ecs-alb-r53-servicediscovery/localstack_aws_provider.tf $(TF_PROVIDER_FILE)
	docker-compose up -d || echo

unset-local:
	docker-compose down

# source: https://www.infracost.io/docs/
estimate:
	infracost breakdown --path .
