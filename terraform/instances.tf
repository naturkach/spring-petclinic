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
  user_data                   = file("install_soft.sh")

  provisioner "file" {
     source      = "~/.ssh/id_rsa"
     destination = "~/.ssh/id_rsa"
 
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
   }
 
  provisioner "file" {
  content      = "${aws_instance.prod-host.public_ip}"
  destination = "/home/ec2-user/test"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "jenkins_master_tf"
  }
   depends_on = [aws_instance.prod-host]
}


#Create and bootstrap CI env EC2 server
resource "aws_instance" "prod-host" {

  ami                         = data.aws_ssm_parameter.MasterAmi.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab-sg.id]
  subnet_id                   = aws_subnet.subnet_cd.id
  tags = {
    Name = "CI environment"
  }
}

