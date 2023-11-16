#!/bin/bash

sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
(wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -) && sudo apt-get update && sudo apt-get install -y postgresql
sudo systemctl stop postgresql
sudo chmod 777 /etc/postgresql/16/main/postgresql.conf 
sudo echo -e "\nhot_standby = on\nlisten_addresses = '*'\n" >> /etc/postgresql/16/main/postgresql.conf
sudo chmod 777 /etc/postgresql/16/main/pg_hba.conf 
sudo echo -e "\nhost all all 0.0.0.0/0 scram-sha-256\n" >> /etc/postgresql/16/main/pg_hba.conf
sudo su - postgres -c "cp -R /var/lib/postgresql/16/main /var/lib/postgresql/16/main_bak"
sudo su - postgres -c "rm -rf /var/lib/postgresql/16/main/*"
echo "replicator" | sudo -S su - postgres -c "pg_basebackup -h $MAIN_DB_IP -D /var/lib/postgresql/16/main -U replicator -P -v -R"
sudo systemctl start postgresql