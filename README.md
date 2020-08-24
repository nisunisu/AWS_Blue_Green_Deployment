# My Terraform test repository
- This repo is just for the purpose of personal Terraform practice.
- Current goals are:
  - [x] Contains VPC, EC2, RDS, ALB
  - [x] Manage EC2 images with Packer
  - [x] Manage EC2 contents with Ansible
  - [x] EC2 Blue/Green deployment
  - [x] ALB with weighted target groups
  - [ ] EC2 auto scaling group
  - [ ] Web App
  - [ ] RDS master/slave
  - [ ] Apply this repo's contents to another cloud services (Azure, GCP etc)

# Requirements
- Terraform (version >= 0.12)
- Packer (version >= 1.6.0)
- AWS CLI (version >= 2)
- Appropriate IAM user(s)