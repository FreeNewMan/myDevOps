provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
}

variable "ubuntu_account_number" {
  default = "099720109477"
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}



data "aws_caller_identity" "current" {}


data "aws_region" "current" {}