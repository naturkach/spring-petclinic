#Get Linux AMI ID using SSM Parameter endpoint in our region
data "aws_ssm_parameter" "MasterAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2
resource "aws_key_pair" "master-key" {
  key_name   = "labkey"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create and bootstrap EC2 jenkins master
resource "aws_instance" "jenkins-master" {
  ami                         = data.aws_ssm_parameter.MasterAmi.value
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab-sg.id]
  subnet_id                   = aws_subnet.subnet_ci.id
  user_data                   = "${file("install_jenkins.sh")}"
  tags = {
    Name = "jenkins_master_tf"
  }
}


#Create and bootstrap Prod EC2 server
resource "aws_instance" "prod-host" {

  ami                         = data.aws_ssm_parameter.MasterAmi.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab-sg.id]
  subnet_id                   = aws_subnet.subnet_cd.id
  tags = {
    Name = "Production server"
  }
}

