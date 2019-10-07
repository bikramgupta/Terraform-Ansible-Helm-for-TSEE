variable "shared_credentials_file" {
  type      = string
  default   = "/home/ubuntu/.aws/credentials" 
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = var.shared_credentials_file
  profile                 = "default"
}

module "bg_centos_workers" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "bikram-centos-cluster"
  instance_count         = 1

  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t2.xlarge"
  key_name               = "singlenodek8saws"
  vpc_security_group_ids = ["sg-9ba806da"]
  subnet_id              = "subnet-b16de7d6"
  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = 200
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dockerEE"
  }

user_data = <<EOF
#!/bin/bash
sudo yum update -y
EOF
}

module "bg_centos_masters" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "bikram-centos-cluster"
  instance_count         = 1

  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t2.2xlarge"
  key_name               = "singlenodek8saws"
  vpc_security_group_ids = ["sg-9ba806da"]
  subnet_id              = "subnet-b16de7d6"
  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = 200
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dockerEE"
  }

user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install epel-release -y
sudo yum install jq -y
EOF
}
