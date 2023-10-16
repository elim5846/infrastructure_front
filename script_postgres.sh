#!/bin/bash

sudo apt-get update && sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo -u postgres psql -c "create user azureadmin superuser" 
sudo -u postgres psql -c "create database todo_db;"
sudo -u postgres psql -c "create user docker with encrypted password 'docker';" 
sudo -u postgres psql -c "grant all privileges on database todo_db to docker;"
psql -U azureadmin -d todo_db -a -f backend/init.sql
sudo chmod 777 /etc/postgresql/14/main/postgresql.conf
sudo echo -e "\nlisten_addresses = '*'\nwal_level = replica\n" >> /etc/postgresql/14/main/postgresql.conf 
sudo chmod 777 /etc/postgresql/14/main/pg_hba.conf 
sudo echo -e "\nhost all all 0.0.0.0/0 md5\n" >> /etc/postgresql/14/main/pg_hba.conf
sudo systemctl restart postgresql