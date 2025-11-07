#!/bin/bash
echo "Running ApplicationStart script..."
echo "Starting Apache (httpd) on Amazon Linux 2023..."
sudo systemctl enable httpd
sudo systemctl restart httpd
