resource "aws_vpc" "vpc" {
  # This (cidr_block) can go in as a variable to enable multiple environments for multiple customers/use cases
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  # This (cidr_block) can go in as a variable to enable multiple environments for multiple customers/use cases
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Main Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "big-main-table" {
  vpc_id = aws_vpc.vpc.id
  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      egress_only_gateway_id     = null
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      gateway_id                 = aws_internet_gateway.gw.id
      instance_id                = null
      local_gateway_id           = null
      nat_gateway_id             = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
      ipv6_cidr_block            = null
    },
  ]

  depends_on = [
    aws_internet_gateway.gw,
    aws_vpc.vpc,
    aws_subnet.subnet,
  ]

  tags = {
    Name = "Main Route Table"
  }

}

resource "aws_main_route_table_association" "route-table-association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.big-main-table.id
  depends_on = [
    aws_route_table.big-main-table
  ]
}

# If you notice a lot of removed depends, if terraform knows you need aws_vpc.vpc.id it'll make aws_vpc.vpc before attemting to create this resource.
