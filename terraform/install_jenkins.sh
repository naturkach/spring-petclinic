#!/bin/bash
sudo yum -y update

echo "Install Java JDK 8"
yum remove -y java
yum install -y java-1.8.0-openjdk 

echo "Install Maven"
yum install -y maven 

echo "Install git" >> /home/ec2-user/log
yum install -y git

echo "Install Docker engine" >> /home/ec2-user/log
yum update -y
yum install docker -y
#sudo chkconfig docker on 

echo "Install Jenkins" >> /home/ec2-user/log
wget -O /etc/yum.repos.d/jenkins.repo 'http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo' >> /home/ec2-user/log
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum upgrade
yum install -y jenkins  >> /home/ec2-user/log
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on
sudo service docker start >> /home/ec2-user/log
sudo service jenkins start >> /home/ec2-user/log
