resource "aws_route_table" "example" {
  vpc_id = aws_vpc.vpc.id
}