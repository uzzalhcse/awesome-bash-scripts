#!/bin/zsh

# Update the system packages
sudo apt update -y

# Install Java Development Kit (JDK)
sudo apt install default-jdk -y

# Download Apache JMeter
wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.5.tgz

# Extract the downloaded archive
tar -xf apache-jmeter-5.5.tgz

# Move JMeter directory to /opt
sudo mv apache-jmeter-5.5 /opt/

# Set environment variables
echo "export JMETER_HOME=/opt/apache-jmeter-5.5" >> ~/.zshrc
echo "export PATH=\$JMETER_HOME/bin:\$PATH" >> ~/.zshrc
source ~/.zshrc

# Install additional JMeter plugins manager
wget https://jmeter-plugins.org/files/packages
