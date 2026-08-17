#!/bin/bash
set -e

dnf install -y nginx
systemctl enable --now nginx