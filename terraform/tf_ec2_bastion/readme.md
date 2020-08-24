# Create bastion EC2 to which you can connect via SSH
And from bastion EC2, you can further connect to other EC2s via SSH.

# Prerequisites
- `terraform apply` in `tf_vpc/` directory has done
- At least one of there ec2 configuration has been `apply`ed.
  - `terraform apply` in `tf_ec2_blue/` directory has done
  - `terraform apply` in `tf_ec2_blue/` directory has done

# Variables
These 3 variables are described in ignored file. So specify them like:
- key_name         = "your_keypair_name"
- path_private_key = "your_local_path_to_private_key" # e.g. : "~/my_keypair.pem"
- my_home_ip       = "123.456.789.012"                # Your public ip address.

# Notice
- Run `terraform apply` here only when you need to connect to "ec2_blue" or "ec2_green" via SSH.
- After your operation, it is recommended to run `terraform destroy` for some security reasons.