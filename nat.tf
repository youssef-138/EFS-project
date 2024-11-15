resource "aws_eip" "nat" {
  vpc = true
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "main-nat-gateway"
  }
}