#!/bin/bash

# Check if Composer is already installed
if [ -x "$(command -v composer)" ]; then
    echo "Composer is already installed."
    exit 0
fi

# Download and install Composer
EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('sha384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    echo "ERROR: Invalid installer signature."
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RESULT=$?

# Cleanup
rm composer-setup.php

# Check the installation result
if [ $RESULT -eq 0 ]; then
    echo "Composer installation completed successfully!"
    exit 0
else
    echo "Failed to install Composer. Please check your setup."
    exit 1
fi
