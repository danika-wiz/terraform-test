# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = us-east-2
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

module "wiz" {
  source        = "https://s3-us-east-2.amazonaws.com/wizio-public/deployment-v2/aws/wiz-aws-native-terraform-terraform-module.zip"
  external-id   = "b1af0ff4-f15b-46f0-aa77-d928f254babe"
  data-scanning = false
  lightsail-scanning = false
  eks-scanning         = false
  remote-arn    = "arn:aws:iam::197171649850:role/prod-us20-AssumeRoleDelegator"
}

output "wiz_connector_arn" {
  value = module.wiz.role_arn
}
