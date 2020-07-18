provider "aws" {
  profile = var.aws_profile # Refer to "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}