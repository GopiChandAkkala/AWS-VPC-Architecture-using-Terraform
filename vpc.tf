resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-Project"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
    vpc_id = aws_vpc.my-vpc.id

    tags = {
      Name = "VPC-Project-InternetGateway"
    }
  
}

resource "aws_route_table" "subnet-rt" {
    vpc_id = aws_vpc.my-vpc.id

    route {
       cidr_block = "0.0.0.0/0"
       gateway_id = aws_internet_gateway.internet-gateway.id
    }
    
    tags = {
      Name = "Public Subnets Route Table"
    }
}

resource "aws_route_table_association" "subnet-association" {
    count = length(var.public_subnet_cidr)
    route_table_id = aws_route_table.subnet-rt.id
    subnet_id = element(aws_subnet.public-subnets[*].id,count.index)
  
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public-subnets[1].id
}

# Elastic IP without instance
resource "aws_eip" "my_eip" {
  # No need to specify "instance" here
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
      Name = "Private Subnets Route Table"
    }
}

# Add Route for Private Subnet to NAT Gateway
resource "aws_route" "private_subnet_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_route_association" {
  count = length(var.private_subnet_cidr)
  subnet_id = element(aws_subnet.private-subnets[*].id,count.index)
  route_table_id = aws_route_table.private_route_table.id
}