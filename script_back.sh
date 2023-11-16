#!/bin/bash

cd backend
echo POSTGRES_USER=$POSTGRES_USER >> .env
echo POSTGRES_PASSWORD=$POSTGRES_PASSWORD >> .env
echo POSTGRES_HOST=$POSTGRES_HOST >> .env
echo POSTGRES_HOST_REPLICATE=$POSTGRES_HOST_REPLICATE >> .env
echo POSTGRES_DB=$POSTGRES_DB >> .env
sudo apt-get update && sudo apt-get install -y nodejs
sudo apt-get update && sudo apt-get install -y npm 
sudo npm install -g n
sudo n stable 
hash -r
sudo npm install -g pm2
npm install
pm2 --name HelloWorld start npm -- start