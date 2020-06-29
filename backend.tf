# -----------------------------------------------------------------
# Terraform backend
terraform {
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true
    key     = "terraform.tfstate"
    # Variables NOT allowed here. So, about those items below, See .tfbackend
    #   - bucket
    #   - profile
  }
}