# Name
My terraform test.

This repo is just for the perpose of personal terraform trying.

# Requirement
- aws cli (version >= 2)
  - Use for aws credential
- Terraform

# Installation
- [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html )

# Progress
- [x] [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install)
- [x] [Build Infrastructure](https://learn.hashicorp.com/terraform/getting-started/build)
- [x] [Change Infrastructure](https://learn.hashicorp.com/terraform/getting-started/change)
- [x] [Destory Infrastructure](https://learn.hashicorp.com/terraform/getting-started/destroy)
- [x] [Resource Dependencies](https://learn.hashicorp.com/terraform/getting-started/dependencies)
- [x] [Provision](https://learn.hashicorp.com/terraform/getting-started/provision)
- [x] [Input Variables](https://learn.hashicorp.com/terraform/getting-started/variables)
- [x] [Output Variables](https://learn.hashicorp.com/terraform/getting-started/outputs)
- [ ] [Remote State Storage](https://learn.hashicorp.com/terraform/getting-started/remote)

# For debugging
Set environmental variable.

## Referrence
- [Debugging Terraform](https://www.terraform.io/docs/internals/debugging.html)

## Windows
```PowerShell
# Set TEMPORARILY
$env:TF_LOG="TRACE" # TRACE, DEBUG, INFO, WARN or ERROR
$env:TF_LOG_PATH="./terraform.log"

# Set PERMANENTLY
[System.Environment]::SetEnvironmentVariable("TF_LOG", "TRACE", "User")
[System.Environment]::SetEnvironmentVariable("TF_LOG_PATH", "./terraform.log", "User")
# need to restart powershell console
```

# Procedures
## Terraform
```bash
cd .aws
ls -l ./*.tf # confirm .tf file presence.

terraform init
terraform init -backend-config="variables_SECRET.tfbackend"

terraform workspace new stg
terraform workspace new prd
terraform workspace select prd # make and select workspace
terraform workspace list

terraform fmt # rewrite Terraform configuration files to a canonical format and style.

terraform plan # Check the plan to execute.

terraform validate # validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc

terraform apply # With "--auto-approve" option, No need to input "yes".

terraform output public_ip # "output" can be used after "apply"

terraform show

terraform destroy # With "--auto-approve" option, No need to input "yes".
```

## Connect to RDS via mysql client
```bash
mysql -h ${rds_endpoint_name} -P 3306 -u ${db_username} -p
```