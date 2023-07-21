#!/bin/bash

# Check if MySQL is already installed
if [ -x "$(command -v mysql)" ]; then
    echo "MySQL is already installed."
else
    # Install MySQL Server (Assuming you are using apt package manager)
    echo "Installing MySQL..."
    sudo apt update
    sudo apt install -y mysql-server
    echo "MySQL installation completed."
fi

# Secure MySQL installation and set root password
#echo "Securing MySQL installation..."
#sudo mysql_secure_installation

# Prompt user to set root password
read -s -p "Enter new password for MySQL root user: " MYSQL_ROOT_PASSWORD

# Set MySQL root password using mysql command-line
echo "Setting MySQL root password..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

echo "MySQL root password set successfully!"
