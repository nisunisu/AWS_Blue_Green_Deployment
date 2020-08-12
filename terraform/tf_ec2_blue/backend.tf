terraform {
  backend "s3" {
    key     = "terraform_ec2_blue.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    encrypt = true
    # Variables NOT allowed here. To use variables, use .tfbackend file.
  }
}