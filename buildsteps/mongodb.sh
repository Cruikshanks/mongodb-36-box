#!/bin/bash -x

# This script needs to be run as a privileged user

# Import the public key used by the package management system
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5

# Create a list file for MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

# Reload local package database.
apt-get update > /dev/null

# Install a specific release of MongoDB
apt-get install -y mongodb-org=3.6.3 mongodb-org-server=3.6.3 mongodb-org-shell=3.6.3 mongodb-org-mongos=3.6.3 mongodb-org-tools=3.6.3

# Pin a specific version of MongoDB
# Although you can specify any available version of MongoDB, apt-get will
# upgrade the packages when a newer version becomes available. To prevent
# unintended upgrades, pin the package.
echo "mongodb-org hold" | dpkg --set-selections
echo "mongodb-org-server hold" | dpkg --set-selections
echo "mongodb-org-shell hold" | dpkg --set-selections
echo "mongodb-org-mongos hold" | dpkg --set-selections
echo "mongodb-org-tools hold" | dpkg --set-selections

# Start MongoDB
service mongod start

# Sleep for 5 seconds to give a chance for mongodb to start
sleep 5s

# Create global admin user
mongo admin --eval 'db.createUser({ user: "mongoAdmin" , pwd: "password1234", roles: [ "userAdminAnyDatabase", "dbAdminAnyDatabase", "readWriteAnyDatabase"]})'

service mongod stop

# Configure the server to use authorization
# Replace a commented out line in the config file with one that enables security
sed -i 's|#security:|security:\n  authorization: enabled|g' /etc/mongod.conf

# Configure the server to listen on all interfaces
# In 3.6 to bind to all IPv4 addresses, you enter 0.0.0.0
sed -i 's|bindIp: 127.0.0.1|bindIp: 0.0.0.0|g' /etc/mongod.conf

service mongod start
