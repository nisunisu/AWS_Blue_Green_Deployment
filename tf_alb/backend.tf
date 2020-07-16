terraform {
  backend "s3" {
    key     = "terraform_alb.tfstate"
    encrypt = true
    # Variables NOT allowed here. So, about those items below, See .tfbackend
    #   - bucket
    #   - profile
    #   - region
  }
}