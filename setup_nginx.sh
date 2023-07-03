#!/bin/bash

# Check if the script is being run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run the script as root."
    exit
fi

# Read existing server list from Nginx configuration
existing_servers=$(grep -R "server_name" /etc/nginx/sites-available/* | awk '{print $2}' | cut -d';' -f1)

# Function to validate if a server name already exists
validate_server_name() {
    local server_name="$1"
    for existing_server in $existing_servers; do
        if [ "$existing_server" = "$server_name" ]; then
            echo "Server name '$server_name' already exists. Exiting."
            exit
        fi
    done
}

# Read existing hosts from hosts file
existing_hosts=$(grep -E '^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\s+' /etc/hosts | awk '{print $2}')

# Display existing hosts in a table view with 4 items per row
echo "Existing hosts:"
count=0
for host in $existing_hosts; do
    printf "%-20s" "$host"
    count=$((count + 1))
    if [ $((count % 4)) -eq 0 ]; then
        printf "\n"
    fi
done
printf "\n"






# Read user input for server name and application port
read -p "Enter server name (e.g., example.com): " server_name
read -p "Enter application port (e.g., 3000): " app_port

# Validate if the server name already exists
validate_server_name "$server_name"

# Set the root directory based on the server name
root_directory="/var/www/${server_name}"

# Create the server block file
server_block="/etc/nginx/sites-available/${server_name}"

# Check if the server block file already exists
if [ -f "$server_block" ]; then
    echo "The server block file already exists. Exiting."
    exit
fi

# Create the server block configuration
echo "
server {
    listen 80;
    listen [::]:80;

    server_name ${server_name};

    root ${root_directory};
    index index.html index.htm;

    location / {
        proxy_pass http://localhost:${app_port};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
" > "$server_block"

# Create a symbolic link to enable the server block
ln -s "$server_block" "/etc/nginx/sites-enabled/"

# Test Nginx configuration
nginx -t

# Restart Nginx to apply the changes
systemctl restart nginx

# Add the server name to the hosts file
echo "127.0.0.1    ${server_name}" >> /etc/hosts

# Display the success message
echo "Nginx server block created successfully for ${server_name}. Root directory set to ${root_directory}. Application port set to ${app_port}."
