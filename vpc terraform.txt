resource "aws_vpc" "default" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "default"
  }
}
resource "aws_subnet" "public" {
  vpc_id = "vpc-063da1e3bcc528030"
  cidr_block = "10.2.0.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "default-public"
  }
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.default.id
  cidr_block = "10.2.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    "Name" = "default-private"
  }
}
resource "aws_internet_gateway" "default" {
   vpc_id = aws_vpc.default.id
   tags = {
     Name = "default_igw"
   }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    "Name" = "public_routes"
  } 
}
resource "aws_route_table_association" "public_association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_eip" "nat_eip" {
  vpc = true
}
resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public.id
  tags = {
    "Name" = "default_NAT"
  }
} 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    #gateway_id = aws_internet_gateway.default.id
    nat_gateway_id = aws_nat_gateway.default.id
  }
  tags = {
    Name = "private_routes"
  } 
}
  resource "aws_route_table_association" "private_association" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
