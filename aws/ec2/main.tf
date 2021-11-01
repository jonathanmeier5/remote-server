terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-example"
  }
}

resource "aws_security_group" "my_good_security_group" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress = [
    {
      description      = "external ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["72.69.59.113/32"]
      # cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
	{
	      cidr_blocks      = [ "0.0.0.0/0", ]
	      description      = ""
	      from_port        = 0
	      ipv6_cidr_blocks = []
	      prefix_list_ids  = []
	      protocol         = "-1"
	      security_groups  = []
	      self             = false
	      to_port          = 0
	    }
  ]


  tags = {
    Name = "allow_tls"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]
  security_groups = [aws_security_group.my_good_security_group.id]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id            = aws_vpc.my_vpc.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.my_vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "example"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table_association" "b" {
   subnet_id   = aws_subnet.my_subnet.id
   route_table_id = aws_route_table.example.id
   depends_on     = [aws_subnet.my_subnet, aws_route_table.example]
 }

resource "aws_key_pair" "ssh-key-meierj" {
  key_name   = "ssh-key-meierj"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMleEfHrIqBvprAtrh8N6Mu/KE5DYhY49uF0M3ZZxSzG"
}

resource "aws_instance" "foo" {
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  count         = 1
  key_name         = "ssh-key-meierj"

  depends_on = [aws_internet_gateway.gw]
  # this is configured at the network gateway
  # vpc_security_group_ids = [aws_security_group.my_good_security_group.id]

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
}

