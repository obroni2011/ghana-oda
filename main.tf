# configuring our network

resource "aws_vpc" "Accra-VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Creating Public Subnet

resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.Accra-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.Accra-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-pub-sub2"
  }
}
# Creating Private Subnet

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.Accra-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}
resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.Accra-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-priv-sub2"
  }
}

# Creating Route Table 

resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.Accra-VPC.id
}


resource "aws_route_table_association" "Public_sub_association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "Public_sub2_association" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.Accra-VPC.id
}

resource "aws_route_table_association" "Private_sub_association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_route_table_association" "Private_sub_association2" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Accra-VPC.id

  tags = {
    Name = "Prod-igw"
  }
}

resource "aws_route" "Prod-igw-association" {
  route_table_id         = aws_route_table.Prod-pub-route-table.id
  gateway_id             = aws_internet_gateway.Prod-igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_nat_gateway" "Prod-Nat-gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Prod-priv-sub1.id
}

resource "aws_route" "Prod-Nat-association" {
  route_table_id         = aws_route_table.Prod-priv-route-table.id
  nat_gateway_id             = aws_nat_gateway.Prod-Nat-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}