data "aws_route_table" "main_route_table" {
    filter {
        name   = "association.main"
        values = ["true"]
    }
    filter {
        name   = "vpc-id"
        values = [aws_vpc.vpc.id]
    }
}

resource "aws_route_table" "rtbl" {
  vpc_id = data.aws_route_table.main_route_table.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
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