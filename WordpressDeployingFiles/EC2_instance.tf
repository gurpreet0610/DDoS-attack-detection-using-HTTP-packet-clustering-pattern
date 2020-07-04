# Creating AWS EC2 Instance with previously created key pair and security group

resource "aws_instance" "webserver" {
  ami           = "ami-005956c5f0f757d37"
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  security_groups = [ "${aws_security_group.allow_webservices_and_SSH.name}" ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.webserver.public_ip
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum update -y",
    "sudo yum install git -y",
    "sudo yum install docker -y",
    "sudo service docker start",
    "sudo usermod -a -G docker ec2-user",
    "sudo curl -L \"https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
    "sudo chmod +x /usr/local/bin/docker-compose",
    "docker pull mysql:5.7",
    "docker pull wordpress",
    "docker pull phpmyadmin/phpmyadmin",
    "mkdir wordpress_data"    
    ]
  }

  tags = {
    Name = "wordpress_server"
  }

}

# Storing IP address in file
resource "null_resource" "getIp"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.webserver.public_ip} > publicip.txt"
  	}
}
