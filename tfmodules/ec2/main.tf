provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "nginx" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
 
resource "aws_instance" "myec2" {
  count                 = "${var.count}"
  ami                     = "${data.aws_ami.nginx.id}"
  instance_type           = "t2.nano"
  key_name                = "${var.key}"

  #security_groups = ["${aws_security_group.sg_ec2.id}"]
  vpc_security_group_ids =  ["${aws_security_group.sg_ec2.id}"]

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }
  tags {
    Name        = "${var.env}-ec2-${count.index}"
  }
}

resource "aws_security_group" "sg_ec2" {
  name        = "${var.env}_sg_ec2"
  description = "ec2 inbound and outbound"
  #vpc_id      = "vpc-84c166ed"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    //security_groups = ["${var.security_group_access}"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
