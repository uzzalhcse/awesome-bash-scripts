#!/bin/bash

# Prompt user for Node.js version
read -p "Enter the desired Node.js version: " version

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Source NVM to make it available in the current shell session
source ~/.nvm/nvm.sh

# Install the specified Node.js version
nvm install "$version"

# Set the installed Node.js version as the default
nvm alias default "$version"

# Print NPM and Node.js versions
echo "NPM version:"
npm -v
echo "Node.js version:"
node -v