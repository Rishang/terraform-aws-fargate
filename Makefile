# Applies to every targets in the file! https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:

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

# source: https://www.infracost.io/docs/
estimate:
	infracost breakdown --path .
