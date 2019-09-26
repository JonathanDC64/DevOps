#!/bin/bash

# Add necessary locale value
echo 'LC_ALL=en_US.UTF-8' >> /etc/default/locale
echo 'LC_ALL=en_US.UTF-8' >> ~/.bash_profile
. ~/.bash_profile

# Refresh your repositories
sudo apt-get update

# Install the necessary prerequisites
echo "Installing the prerequisites"

sudo apt-get install -y apache2 php php-mbstring php-zip phpunit unzip libapache2-mod-php

# Set the admin user and password for MySQL database prior to installation
echo "Configuring MySQL"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'

# Install MySQL server
sudo apt-get install -y mysql-server

# Start the DB servrer
sudo service mysql start
sudo service apache2 start