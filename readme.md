# Name
My terraform test.

This repo is just for the perpose of personal terraform trying.

# Requirement
- aws cli (version >= 2)
  - Use for aws credential
- Terraform

# Installation
- [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html )

# Procedures
```bash
cd .aws
ls -l ./*.tf # confirm .tf file presence.

terraform init

terraform fmt # rewrite Terraform configuration files to a canonical format and style.

terraform validate # validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc

terraform apply # With "--auto-approve" option, No need to input "yes".

terraform show

terraform destroy # With "--auto-approve" option, No need to input "yes".
```