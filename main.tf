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

resource "aws_elb" "my_elb" {
  name            = "elbdemo"

  subnets         = ["subnet-921fe4e9", "subnet-da0f1090"]
  security_groups = ["${aws_security_group.sgelb.id}"]


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 3
    timeout             = 15
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}

resource "aws_security_group" "sgelb" {
  name        = "sgelb"
  description = "ELB inbound and outbound"
  #vpc_id     = "${var.vpc_id}"

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
