# Prerequisites
- `terraform apply` in `tf_vpc/` directory has done
- At least one of there ec2 configuration has been `apply`ed.
  - `terraform apply` in `tf_ec2_blue/` directory has done
  - `terraform apply` in `tf_ec2_blue/` directory has done

# Notice
- Run `terraform apply` here only when you need to connect to "ec2_blue" or "ec2_green" via SSH.
- After your operation, it is recommended to run `terraform destroy` for some security reasons.