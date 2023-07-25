#!/bin/bash
echo "Starting to install nginx"
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "Nginx is ready!"
