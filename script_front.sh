#!/bin/bash

sudo apt-get update && sudo apt-get install -y nodejs npm
sudo npm install -g n pm2 && sudo n stable && hash -r
cd todolist
npm install
npm run build
pm2 --name HelloWorld start npm -- start