provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

variable "access_key" {
    type      = string
    default   = "AKIATPAUGR4U3INZQ74T"
    sensitive = true
}

variable "secret_key" {
    type      = string
    default   = "wWpsUnw4X/h6uPCqVLlNyjVxdfmEPN2TsMV0UTUn"
    sensitive = true
}

variable "region" {
    type    = string
    default = "us-east-1"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "main-vpc"
    }
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
    state = "available"
}

resource "aws_subnet" "pub_sub_1" {
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "pub_sub_2" {
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "pri_sub_1" {
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "pri_sub_2" {
    availability_zone = element(data.aws_availability_zones.azs.names, 0)
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "10.0.4.0/24"
}

resource "aws_route_table" "rtbl" {
  vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "rtbl-01"
    }
}

resource "aws_route_table_association" "rtbl-pub_sub1-association" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.rtbl.id
}

resource "aws_route_table_association" "rtbl-pub_sub2-association" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.rtbl.id
}

resource "aws_route_table_association" "rtbl-pri_sub1-association" {
  subnet_id      = aws_subnet.pri_sub_1.id
  route_table_id = aws_route_table.rtbl.id
}

resource "aws_route_table_association" "rtbl-pri_sub2-association" {
  subnet_id      = aws_subnet.pri_sub_2.id
  route_table_id = aws_route_table.rtbl.id
}

resource "aws_route_table_association" "rtbl-igateway-association" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.rtbl.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

#Create SG for allowing TCP/80 & TCP/22
resource "aws_security_group" "sg" {
    name        = "sg"
    description = "Allow TCP/80 & TCP/22"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        description = "Allow SSH traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow traffic from TCP/80"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_network_interface" "nic" {
  subnet_id   = aws_subnet.pub_sub_1.id
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "web-app-server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.sg.id]

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  tags = {
    Name = "webserver01"
  }
}

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