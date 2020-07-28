# My terraform test repo
- This repo is just for the purpose of personal terraform practice.
- Current goals (under making) are:
  - Contains ALB, EC2, RDS
  - Contains EC2 Blue/Green deployment
  - Contains Ansible tasks on EC2 (by terraform or using AMI which has been created beforehand)

# Requirements
- Terraform (version >= 0.12)
- AWS CLI (version >= 2)
- IAM user for Terraform
    1. Create IAM user for Terraform
        
        As IAM permissions, see `./tf_*/readme.md`. 
    1. Create a new aws profile with the IAM user for AWS CLI
        
        In this repository, name the aws profile "terraform_user".
        ```bash
        # Create
        aws configure --profile "terraform_user" # Set it up with IAM access key and secret key
        
        # Set as default profile
        export AWS_PROFILE="terraform_user" # Mac or Linux
        setx AWS_PROFILE "terraform_user"   # Windows (NOTICE : this command is for USER env)
        
        # Show CURRENT aws profile
        # To refresh profile, terminal restart may be required.
        aws configure list  # current aws profile
        echo ${AWS_PROFILE} # Env : Mac or Linux
        Get-ChildItem -Path Env: | Where-Object Name -match "AWS_PROFILE" # Env : Windows PowerShell
        ```
- S3 bucket for Terraform's tfstate
    
    Create a new S3 bucket for Terraform's `backend` and `remote_state` and so on. Here I use `myterraformtest` bucket, but be aware that bucket names must be globally unique so please replace it with another name you like.
    ```bash
    # Create
    aws s3 mb s3://"myterraformtest" # NOTICE : Bucket names must be globally unique. So Replace it with another name you like. 

    aws s3 ls # check

    # Disable public access to the bucket
    aws s3api put-public-access-block --bucket "myterraformtest" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

    aws s3api get-public-access-block --bucket "myterraformtest" # check
    ```

# Terraform resource types
1. `resource`
1. `output`
1. `variable`
    > [Input Variables](https://www.terraform.io/docs/configuration/variables.html)
    > 
    > Terraform also automatically loads a number of variable definitions files if they are present:
    >   - Files named exactly terraform.tfvars or terraform.tfvars.json.
    >   - Any files with names ending in .auto.tfvars or .auto.tfvars.json.
1. `data source`
    > [Data Sources](https://www.terraform.io/docs/configuration/data-sources.html)
    > 
    > Data sources allow data to be fetched or computed for use elsewhere in Terraform configuration. Use of data sources allows a Terraform configuration to make use of information defined outside of Terraform, or defined by another separate Terraform configuration.

    So, describe like this:
    ```tf:data_ec2.tf
    data "aws_instance" "default" {
      filter {
        name   = "tag:Name"
        values = ["the_name_of_ec2_which_can_be_either_inside_or_outside_of_terraform_configuration"]
      }
    }
    output "ec2_default" {
      value = data.aws_instance.default.id
    }
    ```
    When you run `terraform apply` or `terraform output` or `terraform refresh`, the information of `data.aws_instance.default.id` will be displayed on terminal.

# This repo's directory layout
Configurations are created for some componet units.
```bash
Terraform/
+- tf_alb/         # Configuration for AWS ALB, Security Group
+- tf_ec2_bastion/ # Configuration for AWS EC2, Security Group
+- tf_ec2_blue/    # Configuration for AWS EC2, Security Group
+- tf_ec2_grenn/   # Configuration for AWS EC2, Security Group
+- tf_rds/         # Configuration for AWS RDS, Security Group
+- tf_vpc/         # Configuration for AWS VPC, IGW, Subnet, Route Table
-  readme.md
```
And in every `tf_*` directory, there is secret a files which is NOT commit to this repo.
```bash
Terraform/
+- tf_ec2_bastion/
  - variables_SECRET.auto.tfvars # credential variables for `terraform` commands (excluding `init`) are described
```
So, execute `terraform` commands like:
```bash
cd Terraform/tf_vpc
terraform init -backend-config="./variables_SECRET.tfbackend"
terraform plan
terraform apply
terraform destroy
```

# IAM
The aws profile which is used to run `terraform` must have following AWS permissions:
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
- [Debugging Terraform](https://www.terraform.io/docs/internals/debugging.html)

For debugging, set environmental variable(s).

With Windows:
```PowerShell
# Set TEMPORARILY
$env:TF_LOG="TRACE" # TRACE, DEBUG, INFO, WARN or ERROR
$env:TF_LOG_PATH="./terraform.log"

# Set PERMANENTLY
[System.Environment]::SetEnvironmentVariable("TF_LOG", "TRACE", "User")
[System.Environment]::SetEnvironmentVariable("TF_LOG_PATH", "./terraform.log", "User")
# need to restart powershell console
```

With Mac or Linux:
Sorry, I don't know.

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

# Detect any drift from the last-known state, and to update the state file.
# This does not modify infrastructure, but does modify the state file. If the state is changed, this may cause changes to occur during the next plan or apply.
terraform refresh
```

## Connect to RDS via mysql client
```bash
mysql -h ${rds_endpoint_name} -P 3306 -u ${db_username} -p
```

## Connect to Web server via ALB
1. Run `terraform apply` under every component folder (tf_*).
1. Check `aws_lb.default.dns_name` output after `terraform apply` in `tf_alb`
1. Launch any browser you like (e.g. Google chrome)
1. Input `aws_lb.default.dns_name` to address bar and go.
1. If a test page of nginx is appeared, it means you can reach to EC2(web server) via ALB.