provider "aws" {
  profile = "terraform_user" # Refer to "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}