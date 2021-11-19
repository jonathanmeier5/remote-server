#!/bin/bash -e

rsync -avz ~/Projects $(terraform output meierj-remote-uri):/home/ubuntu/Projects
