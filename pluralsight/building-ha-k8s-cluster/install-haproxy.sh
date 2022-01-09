#!/bin/bash
set -e
set -x

source "`dirname "$1"`/config.conf"

sudo apt update
sudo apt install -y haproxy

sudo tee -a /etc/haproxy/haproxy.cfg <<EOF
frontend lb
    bind $haproxyIP:6443
    mode tcp
    option tcplog
    default_backend master

backend master
    mode tcp
    option tcp-check
    balance roundrobin
    server master1 $master1IP:6443 check fall 3 rise 2 
    server master2 $master2IP:6443 check fall 3 rise 2 
    server master3 $master3IP:6443 check fall 3 rise 2 
EOF

sudo systemctl restart haproxy