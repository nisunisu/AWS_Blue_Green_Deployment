# Manage EC2 AMI for blue/green deployment
- Create EC2 AMI with Packer
- EC2 AMI type ("Blue" or "Green") can be specified with command-line variable (See "Packer command" section )

## Contents in AMI
- Base image
  - amazon_linux_2
- Software
  - nginx (enabled)
  - mysql client
  - python3
  - Ansible (including running `ansible-playbook`)
- Files
  - `./ansible` directory (recursively. For `ansible-playbook`)

# Install
- [Install Packer](https://learn.hashicorp.com/packer/getting-started/install)
- No need to install Ansible with your local computer

# Packer command
```bash
packer --version

packer validate -var 'blue_or_green=blue'  ./amazon_linux_2.json
packer build    -var 'blue_or_green=green' ./amazon_linux_2.json

packer validate -var 'blue_or_green=blue'  ./amazon_linux_2.json
packer build    -var 'blue_or_green=green' ./amazon_linux_2.json
```

# Procedure
1. Run `packer build` (See "Packer command" section)
1. Check image ids
    ```PowerShell
    $jsondata = aws ec2 describe-images --owners self --output json | ConvertFrom-Json
    $jsondata.Images | Select-Object -Property ImageId, Name, CreationDate
    ```
1. Describe the image id to the files below:
   1. `../terraform/tf_ec2_blue/ec2.tf`  (the id you created with `packer build -var "blue_or_green=blue"`)
   1. `../terraform/tf_ec2_green/ec2.tf` (the id you created with `packer build -var "blue_or_green=blue"`)
1. Use Terraform
