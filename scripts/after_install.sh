#!/bin/bash
echo "Running AfterInstall script..."
sudo cp -r /home/ec2-user/* /var/www/html/
sudo chown -R ec2-user:ec2-user /var/www/html
