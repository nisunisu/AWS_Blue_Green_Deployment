# Name
This repo is just for the purpose of personal terraform trying.

# Requirement
- aws cli (version >= 2)
  - Use for aws credential
- Terraform

# This repo's directory layout
Configurations are created for some componet units.
```bash
Terraform/
+- tf_alb/    # Configuration for AWS ALB, Security Group
+- tf_ec2/    # Configuration for AWS EC2, Security Group
+- tf_rds/    # Configuration for AWS RDS, Security Group
+- tf_vpc/    # Configuration for AWS VPC, IGW, Subnet, Route Table
-  readme.md
```

# IAM
Following full access permissions are required
- VPC
- RDS
- EC2
- S3
- ELB

# Installation
- [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html )

# Official tutorial
- [Getting Started](https://learn.hashicorp.com/terraform/getting-started/intro)

# Debugging
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
# AWS user is specified in provider.tf

# Initialize terraform (make .terraform folder)
terraform init -backend-config="variables_SECRET.tfbackend"

# Workspaces
terraform workspace new blue
terraform workspace new green
terraform workspace select blue # make and select workspace
terraform workspace list        # show the list of workspaces (and current workspaces)

# rewrite Terraform configuration files to a canonical format and style.
terraform fmt

# Check the plan to execute.
terraform plan

# validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc
terraform validate

# Apply and Destroy
terraform apply   --auto-approve
terraform destroy --auto-approve

# Show outputs
terraform output

# Provide human-readable output from a state or plan file
terraform show
```

## Connect to RDS via mysql client
```bash
mysql -h ${rds_endpoint_name} -P 3306 -u ${db_username} -p
```