#!/bin/bash

sudo apt-get update && sudo apt-get install -y nodejs npm
sudo npm install -g n pm2 && sudo n stable && hash -r
cd todolist
npm install
pm2 --name HelloWorld start npm -- run json-server