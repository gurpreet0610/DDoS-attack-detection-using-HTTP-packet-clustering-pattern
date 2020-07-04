# pulling github repository to EC2 Instance

resource "null_resource" "launching_server"  {

depends_on = [
    null_resource.AttachmentRemoteExecution,
  ]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.webserver.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "cd ~/wordpress_data && ls",
      "docker-compose up -d"
    ]
  }
}