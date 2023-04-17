resource "aws_nat_gateway" "nat-gw" {
  subnet_id         = aws_subnet.pub_sub_1.id
}