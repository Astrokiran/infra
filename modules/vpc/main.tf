resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "vpc-${var.project_name}"
    }
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.project_name}-igw"
    }
}

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnets[count.index]
    map_public_ip_on_launch = true
    # Assign different AZs to each subnet
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.project_name}-public-subnet-${count.index}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
    count = length(var.public_subnets)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnets[count.index]
    map_public_ip_on_launch = false
    # Assign different AZs to each subnet
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "${var.project_name}-private-subnet-${count.index}"
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.project_name}-private-rt"
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.private_subnets)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}