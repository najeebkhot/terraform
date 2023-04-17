#Create and bootstrap webserver
/*resource "aws_instance" "webserver" {
    ami                         = "ami-007855ac798b5175e"
    instance_type               = "t2.micro"
    #key_name                    = aws_key_pair.webserver-key.key_name
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.sg.id]
    subnet_id                   = aws_subnet.pub_sub_1.id
    provisioner "remote-exec" {
        inline = [
        "sudo yum -y install httpd && sudo systemctl start httpd",
        "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
        "sudo mv index.html /var/www/html/"
    ]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
        host        = self.public_ip
        }
    }

    tags = {
        Name = "webserver"
    }

    #ami = "ami-007855ac798b5175e"
}*/

/*resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1"
  tags = {
    Name = "demo-subnet-1"
  }
}*/

resource "aws_network_interface" "nic" {
  subnet_id   = aws_subnet.pub_sub_1.id
  private_ips = ["172.16.10.100"]
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "web-app-server" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]

  network_interface {
    network_interface_id = aws_network_interface.nic.id
    device_index         = 0
  }

  tags = {
    Name = "webserver01"
  }
}
