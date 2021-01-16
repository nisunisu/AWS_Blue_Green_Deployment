module "sg_ec2_green" {
  source = "../module/security_group"
  name = "sg_ec2_green_terraform"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  port = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}