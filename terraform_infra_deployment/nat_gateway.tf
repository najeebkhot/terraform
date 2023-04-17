resource "aws_nat_gateway" "example" {
  subnet_id         = aws_subnet.example.id
}