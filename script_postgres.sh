#!/bin/bash

sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
(wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -) && sudo apt-get update && sudo apt-get install -y postgresql
sudo systemctl start postgresql
sudo -u postgres psql -c "create user azureadmin superuser" 
sudo -u postgres psql -c "create user replicator with REPLICATION encrypted password 'replicator';" 
sudo -u postgres psql -c "create database todo_db;"
sudo -u postgres psql -c "create user docker with encrypted password 'docker';" 
sudo -u postgres psql -c "grant all privileges on database todo_db to docker;"
psql -U azureadmin -d todo_db -a -f backend/init.sql
sudo chmod 777 /etc/postgresql/16/main/postgresql.conf
sudo echo -e "\nlisten_addresses = '*'\nwal_level = replica\n" >> /etc/postgresql/16/main/postgresql.conf 
sudo chmod 777 /etc/postgresql/16/main/pg_hba.conf 
sudo echo -e "\nhost all all 0.0.0.0/0 scram-sha-256\nhost replication replicator 0.0.0.0/0 scram-sha-256" >> /etc/postgresql/16/main/pg_hba.conf
sudo systemctl restart postgresql