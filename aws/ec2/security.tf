resource "aws_security_group" "inbound_ssh_security_group" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress = [
    {
      description      = "external ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["72.69.59.113/32", "${var.where_am_i}/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
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
    Name = "Allow Incoming SSH from My current IP"
  }
}

#resource "aws_network_interface" "foo" {
#  subnet_id       = aws_subnet.my_subnet.id
#  private_ips     = ["172.16.10.100"]
#  security_groups = [aws_security_group.my_good_security_group.id]
#
#  tags = {
#    Name = "primary_network_interface"
#  }
#}



