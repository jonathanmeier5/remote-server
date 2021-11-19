output "meierj-ssh-command" {
  value = "ssh ubuntu@${aws_instance.meierj-instance.public_ip}"
}
