provider "aws" {
  profile = "default" # "default" means "%UserProfile%\.aws\credential" in Windows
  region  = "ap-northeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-07dd14faa8a17fb3e" # RHEL8
  instance_type = "t2.micro"
}