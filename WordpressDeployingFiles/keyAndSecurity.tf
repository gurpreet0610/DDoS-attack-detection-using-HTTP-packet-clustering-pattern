provider "aws" {
	region = "ap-south-1"
	profile = "gurpreetaws"
}

# Creating key_pair for SSH in AWS instance

resource "tls_private_key" "createkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "wordpress_key"
  public_key = tls_private_key.createkey.public_key_openssh
}

resource "null_resource" "savekey"  {
  depends_on = [
    tls_private_key.createkey,
  ]
	provisioner "local-exec" {
	    command = "echo  '${tls_private_key.createkey.private_key_pem}' > wordpress_key.pem"
  	}
}

# Creating Security Group
resource "aws_security_group" "allow_webservices_and_SSH" {
  name        = "allow_webservices_and_SSH"
  description = "Allow webservices and ssh inbound traffic"
  # allow ingress of port 80
  ingress {
    description = "Allow HTTP Wordpress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow ingress of port 8080
  ingress {
    description = "Allow HTTP PHPmyAdmin"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow ingress of port 22
  ingress { 
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_wordpress"
  }
}
