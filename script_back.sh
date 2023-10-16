#!/bin/bash

cd backend
sudo apt-get update && sudo apt-get install -y nodejs
sudo apt-get update && sudo apt-get install -y npm 
sudo npm install -g n
sudo n stable 
hash -r
sudo npm install -g pm2
npm install
pm2 --name HelloWorld start npm -- start