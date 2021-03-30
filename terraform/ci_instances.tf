#Get Linux AMI ID using SSM Parameter endpoint in our region
data "aws_ssm_parameter" "MasterAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#https://stackoverflow.com/questions/49743220/how-do-i-create-an-ssh-key-in-terraform
#Create key-pair for logging into EC2
resource "aws_key_pair" "master-key" {
  key_name   = "labkey"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create and bootstrap EC2 jenkins master
resource "aws_instance" "jenkins-master" {

  ami                         = data.aws_ssm_parameter.MasterAmi.value
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.lab-sg.id]
  subnet_id                   = aws_subnet.subnet_ci.id
  provisioner "local-exec" {
    command = <<EOF
aws --profile default ec2 wait instance-status-ok --region eu-central-1 --instance-ids ${self.id} \
&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_jenkins.yaml
EOF
  }
  tags = {
    Name = "jenkins_master_tf"
  }
}
