output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}

output "Production-Public-IP" {
  value = aws_instance.prod-host.public_ip
}

