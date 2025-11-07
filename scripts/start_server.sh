#!/bin/bash
echo "Running ApplicationStart script..."
sudo systemctl restart httpd || sudo service httpd restart
