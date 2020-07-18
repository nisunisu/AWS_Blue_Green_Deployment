terraform {
  backend "s3" {
    key     = "terraform_alb.tfstate"
    profile = "terraform_user"
    region  = "ap-northeast-1"
    bucket  = "myterraformtest"
    encrypt = true
    # Variables NOT allowed here. To use variables, use .tfbackend file.
  }
}