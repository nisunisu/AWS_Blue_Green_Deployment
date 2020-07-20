data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    key     = "terraform_vpc.tfstate" # Get remote state from "tf_vpc" folder's output
  }
}
data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    key     = "terraform_ec2.tfstate" # Get remote state from "tf_ec2" folder's output
  }
}