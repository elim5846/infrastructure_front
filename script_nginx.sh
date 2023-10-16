#!/bin/bash

sudo apt update && sudo apt install -y nginx

cat > /etc/nginx/sites-available/loadbalancer <<EOF
upstream backend {
    server 192.168.1.101;
    server 192.168.1.102;
}

server {
    listen 80;
    server_name myloadbalancer;

    location / {
        proxy_pass http://backend;
    }
}
EOF

ln -s /etc/nginx/sites-available/loadbalancer /etc/nginx/sites-enabled/

nginx -t

systemctl restart nginx

systemctl enable nginx

exit 0