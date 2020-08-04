data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    key     = "terraform_vpc.tfstate" # Get remote state from "tf_vpc" folder's output
  }
}

data "terraform_remote_state" "ec2_blue" {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    key     = "terraform_ec2_blue.tfstate"
  }
}

data "terraform_remote_state" "ec2_green" {
  backend = "s3"
  config = {
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    key     = "terraform_ec2_green.tfstate"
  }
}