#!/bin/bash -e -x

$(terraform output --raw meierj-ssh-command) "mkdir -p /home/ubuntu/Projects/$1"
rsync -avz ~/Projects/$1 $(terraform output --raw meierj-remote-uri):/home/ubuntu/Projects/$1
