# Creating EBS volumes and Attach to EC2 Instance

resource "aws_ebs_volume" "myebs" {
  availability_zone = aws_instance.webserver.availability_zone
  size              = 1
  snapshot_id = "snap-073cb7ab26e8050be"
  tags = {
    Name = "servervol"
  }
}

resource "aws_volume_attachment" "attach_ebs" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.myebs.id
  instance_id = aws_instance.webserver.id
  force_detach = true
}

resource "null_resource" "AttachmentRemoteExecution"  {

depends_on = [
    aws_volume_attachment.attach_ebs,
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("wordpress_key.pem")
    host     = aws_instance.webserver.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "cd /dev/xvdh && ls",
      "sudo mount  /dev/xvdh  ~/wordpress_data",
    ]
  }

}
# "sudo mkfs.ext4  /dev/xvdh",