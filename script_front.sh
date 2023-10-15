#!/bin/bash

sudo apt-get update && sudo apt-get install -y nodejs
sudo apt-get update && sudo apt-get install -y npm && sudo npm install -g n pm2 && sudo n stable && hash -r
cd todolist
npm install
npm run build
pm2 --name HelloWorld start npm -- start