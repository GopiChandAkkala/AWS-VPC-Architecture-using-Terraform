resource "aws_subnet" "public-subnets" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = element(var.public_subnet_cidr,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = true
    
    tags = {
      Name = "Public Subnet ${count.index + 1}"
    }
}

resource "aws_subnet" "private-subnets" {    
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = element(var.private_subnet_cidr,count.index)
    availability_zone = element(var.azs,count.index)

    tags = {
      Name = "Private Subnet ${count.index + 1}"
    }
}
