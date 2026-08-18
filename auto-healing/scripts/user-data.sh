#!/bin/bash
set -e

dnf install -y docker
systemctl enable --now docker

docker pull keandre2045/auto-healing-web:latest

docker run -d \
  --name nginx-web \
  --restart unless-stopped \
  -p 80:80 \
  keandre2045/auto-healing-web:latest