#!/bin/bash

# Function to install Nginx
install_nginx() {
  sudo apt update
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
}

# Function to install PHP and extensions
install_php() {
  sudo apt update
  sudo apt upgrade
  sudo apt install ca-certificates apt-transport-https
  sudo apt install software-properties-common
  sudo add-apt-repository ppa:ondrej/php
  sudo apt install php$1 php$1-fpm
#  sudo systemctl status php$1-fpm
  sudo apt-get install -y php$1-cli php$1-common php$1-mysql php$1-zip php$1-gd php$1-mbstring php$1-curl php$1-xml php$1-bcmath
  sudo systemctl restart nginx
}

# Check if Nginx is already installed
if ! [ -x "$(command -v nginx)" ]; then
  echo "Nginx is not installed. Installing Nginx..."
  install_nginx
else
  echo "Nginx is already installed."
fi

# Ask the user for PHP version
read -p "Enter the PHP version you want to install (e.g., 7.4, 8.0): " version

# Check if the input is a valid PHP version
#if [ "$version" != "7.4" ] && [ "$version" != "8.0" ]; then
#  echo "Invalid PHP version. Please enter a valid version (e.g., 7.4, 8.0)."
#  exit 1
#fi

# Check if PHP is already installed
if dpkg --get-selections | grep -q "^php$version[[:space:]]*install$" ; then
  echo "PHP version $version is already installed."
else
  install_php "$version"
  echo "PHP version $version has been installed."
fi
