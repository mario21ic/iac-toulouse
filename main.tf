provider "aws" {
  region = "us-east-2"
}
 
resource "aws_instance" "myec2" {
  ami                     = "ami-0cf31d971a3ca20d6"
  instance_type           = "t2.nano"
  key_name                = "workshop_tls"

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
}

