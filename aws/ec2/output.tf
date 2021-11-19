output "meierj-ssh-command" {
  value = "ssh ubuntu@${aws_instance.meierj-instance.public_ip}"
}

output "meierj-remote-uri" {
  value = "ubuntu@${aws_instance.meierj-instance.public_ip}"
}
