
resource "aws_instance" "meierj-instance" {
  key_name = "ssh-key-meierj"

  # Ok so a static ami is a good thing, the latest ami you want is better.

  #  ami           = "ami-02e136e904f3da870"

  ami = data.aws_ami.ubuntu.id

  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [
    aws_security_group.inbound_ssh_security_group.id
  ]
  depends_on = [
    aws_internet_gateway.gw,
  ]
}
