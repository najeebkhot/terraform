resource "aws_launch_template" "template" {
  name_prefix   = "web-app-server"
  image_id      = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "auto-scale-group" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 3
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
  
}