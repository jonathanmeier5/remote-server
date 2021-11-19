
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

  # 
  # Find more about connection here:
  # https://www.terraform.io/docs/language/resources/provisioners/connection.html
  #
  # This is used by remote-exec and file
  # 
  # "remote-exec" and "local-exec" should be viewed as vehicles of last resort.
  # 

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/aws")
    host        = self.public_ip
    timeout     = "2m"
  }


  #
  # Has singular and plural forms (script vs scripts)
  # Is confusing
  # Use as a last resort only.
  #
  # https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html
  #

  provisioner "remote-exec" {
    scripts = [
      "scripts/create_local_file.sh",
      "scripts/setup.sh"
    ]
  }

#  provisioner "local-exec" {
#    command = "./scripts/sync.sh"
#  }

  #
  # Super handy, you can specify source, or contents
  #
  # https://www.terraform.io/docs/language/resources/provisioners/file.html
  #

  provisioner "file" {
    source      = "files/bashrc"
    destination = "personal_bashrc"
  }

  provisioner "file" {
    source      = "files/vscodeconfig"
    destination = "remote_vscodeconfig"
  }


}
