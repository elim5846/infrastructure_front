#!/bin/bash

sudo apt-get update && sudo apt-get install postgresql postgresql-contrib && sudo systemctl start postgresql && sudo -u postgres psql -c "CREATE DATABASE todo_db;"