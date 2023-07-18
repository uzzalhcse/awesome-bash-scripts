#!/bin/bash

sudo apt-get update
sudo apt-get install -y gnupg wget lsb-release
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql-pgdg.list &> /dev/null
sudo apt-get update
sudo apt-get install -y postgresql-15

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'root';"