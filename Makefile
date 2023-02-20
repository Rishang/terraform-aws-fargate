# Applies to every targets in the file! https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:

TF_PROVIDER_FILE = https://gitlab.com/-/snippets/2498907/raw/main/localstack_terraform_conf.tf
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
	(docker-compose pull && docker-compose up -d) || echo

unset-local:
	docker-compose down

# source: https://www.infracost.io/docs/
estimate:
	infracost breakdown --path .

clean:
	find . -type f  -regex  '.*/terraform.tfstate.*' | xargs rm -f

test:
	bash .github/scripts/test.sh
