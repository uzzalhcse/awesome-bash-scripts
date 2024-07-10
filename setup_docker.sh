#!/bin/bash

# Check if the PROJECT_DIR argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <PROJECT_DIR>"
  exit 1
fi

PROJECT_DIR=$1

# Export the PROJECT_DIR environment variable
export PROJECT_DIR

# Update your existing list of packages
echo "Updating package list..."
sudo apt update -y

# Install prerequisite packages which let apt use packages over HTTPS
echo "Installing prerequisite packages..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the GPG key for the official Docker repository to your system
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker repository to APT sources
echo "Adding Docker repository..."
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Update the package database with the Docker packages from the newly added repo
echo "Updating package list with Docker packages..."
sudo apt update -y

# Verify that Docker will be installed from the Docker repository
echo "Verifying Docker installation source..."
if apt-cache policy docker-ce | grep -q "download.docker.com"; then
    echo "Docker will be installed from the official Docker repository."
else
    echo "Docker repository setup failed."
    exit 1
fi

# Install Docker
echo "Installing Docker..."
sudo apt install -y docker-ce

# Check if Docker is running
echo "Checking Docker status..."
sudo systemctl status docker --no-pager

