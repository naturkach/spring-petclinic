######vars
variable "region-master" {
  type    = string
  default = "eu-central-1"
}

variable "profile" {
  type    = string
  default = "default"
}

provider "aws" {
  profile = var.profile
  region  = var.region-master
  alias   = "region-master"
}

#########
#Create VPC
resource "aws_vpc" "vpc_lab" {
  provider             = aws.region-master
  cidr_block           = "192.168.0.0/23"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-lab"
  }
}

#Create IGW
resource "aws_internet_gateway" "igwlab" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_lab.id
  tags = {
    Name = "lab gateway"
  }
}

#Create subnet # 1 build
resource "aws_subnet" "subnet_build" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.vpc_lab.id
  cidr_block = "192.168.0.0/24"
  tags = {
    Name = "building subnet"
  }
}

#Create subnet # 1 prod
resource "aws_subnet" "subnet_prod" {
  provider   = aws.region-master
  vpc_id     = aws_vpc.vpc_lab.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "production subnet"
  }
}

#Create route table
resource "aws_route_table" "internet_route_lab" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igwlab.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "lab-route-table"
  }
}

#################
#SGroups
#Create SG for allowing TCP/8080 from * and TCP/22 from *
resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_lab.id
  ingress {
    description = "Allow 22 from any"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow anyone on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "lab build sg"
  }
}










