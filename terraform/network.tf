#Create VPC
resource "aws_vpc" "vpc_lab" {
  cidr_block           = "192.168.2.0/23"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "lab VPC"
  }
}


#Create IGW
resource "aws_internet_gateway" "lab_gw" {
  vpc_id = aws_vpc.vpc_lab.id
  tags = {
    Name = "lab Gateway"
  }
}

#Create subnet 1 build
resource "aws_subnet" "subnet_ci" {
  vpc_id     = aws_vpc.vpc_lab.id
  cidr_block = "192.168.2.0/24"
  tags = {
    Name = "CI subnet"
  }
}

#Create subnet 2 prod
resource "aws_subnet" "subnet_cd" {
  vpc_id     = aws_vpc.vpc_lab.id
  cidr_block = "192.168.3.0/24"
  tags = {
    Name = "CD subnet"
  }
}


#Create route table
resource "aws_route_table" "internet_route_lab" {
  vpc_id = aws_vpc.vpc_lab.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_gw.id
 
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "lab-route-table"
  }
 }
}


#assosiate networks with route table
resource "aws_route_table_association" "ci_assoc" {
  subnet_id      = aws_subnet.subnet_ci.id
  route_table_id = aws_route_table.internet_route_lab.id
}
resource "aws_route_table_association" "cd_assoc" {
  subnet_id      = aws_subnet.subnet_cd.id
  route_table_id = aws_route_table.internet_route_lab.id
}


#SGroups
#Create SG for allowing TCP/8080 from * and TCP/22 from *
resource "aws_security_group" "lab-sg" {
  name        = "lab-sg"
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
    Name = "lab security group"
  }
}

