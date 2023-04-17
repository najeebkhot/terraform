resource "aws_ebs_volume" "block_store" {
  availability_zone = "us-east-1a"
  size              = 10

  tags = {
    Name = "block-store-1"
  }

}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.block_store.id
  instance_id = aws_instance.web-app-server.id
}