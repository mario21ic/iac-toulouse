provider "aws" {
  region = "us-east-2"
}
 module "aws_instance" {
  source = "./tfmodules/ec2/"

  region = "us-east-2"
  ami  = "nginx_tls"
  key = "workshop_tls"
  env = "draft"
  count = 2
}
