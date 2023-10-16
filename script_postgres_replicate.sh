#!/bin/bash

sudo apt-get update && sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl stop postgresql
sudo chmod 777 /etc/postgresql/14/main/postgresql.conf
sudo echo -e "\nhot_standby = on\n" >> /etc/postgresql/14/main/postgresql.conf 
sudo su - postgres -c "cp -R /var/lib/postgresql/14/main /var/lib/postgresql/14/main_bak"
sudo su - postgres -c "rm -rf /var/lib/postgresql/14/main/*"
echo "replicator" | sudo -S su - postgres -c "pg_basebackup -h $MAIN_DB_IP -D /var/lib/postgresql/14/main -U replicator -P -v -R"
sudo systemctl start postgresql