data "aws_availability_zones" "available" {}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  count                   = length(var.public_subnets_cidrs)
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index] # Change this to your desired availability zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-public_subnet0${count.index + 1}"
    }
  )
}

resource "aws_subnet" "private_application_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.private_application_subnets_cidrs)
  cidr_block        = element(var.private_application_subnets_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-private-application_subnet0${count.index + 3}"
    }
  )
}

resource "aws_subnet" "private_data_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  count             = length(var.private_data_subnets_cidrs)
  cidr_block        = element(var.private_data_subnets_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.resource_tags["Project"]}-private-data_subnet0${count.index +5}"
    }
  )
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-IGW"
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-Public_subnets01-02-RouteTable"
    }
  )
}


resource "aws_route_table_association" "public-subnets-route_table_association" {
  count          = length(var.public_subnets_cidrs)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-NatGW"
    }
  )
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_route_table" "private_application_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-Private_application_subnets03-04-RouteTable"
    }
  )
}

resource "aws_route_table_association" "private_application_subnets-route_table_association" {
  count          = length(var.private_application_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_application_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_application_route_table.id
}


resource "aws_route_table" "private_data_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.aws_region}-${var.resource_tags["Project"]}-Private_data_subnets05-06-RouteTable"
    }
  )
}

resource "aws_route_table_association" "private_data-subnets-route_table_association" {
  count          = length(var.private_data_subnets_cidrs)
  subnet_id      = element(aws_subnet.private_data_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_data_route_table.id
}