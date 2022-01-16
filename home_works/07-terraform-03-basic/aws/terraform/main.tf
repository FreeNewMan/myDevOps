provider "aws" {
  profile = "default"
  region  = "us-west-2"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["${var.ubuntu_account_number}"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*16*-amd64-server-*"]
  }
}

variable "ubuntu_account_number" {
  default = "099720109477"
}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
	prod = "t3.large"
  }
  
  web_instance_count_map = {
    stage = 1
	prod = 2
  }  
  
  instances = {
    "t3.micro" = data.aws_ami.ubuntu.id
	"t3.large" = data.aws_ami.ubuntu.id
  }
  
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count = local.web_instance_count_map[terraform.workspace]
  
  
  tags = {
    Name = "HelloWorld1"
  }
}


resource "aws_instance" "web1" {
  for_each = local.instances 
  ami = each.value
  instance_type = each.key
  
  lifecycle {
    create_before_destroy = true
  }
  
}



data "aws_caller_identity" "current" {}


data "aws_region" "current" {}