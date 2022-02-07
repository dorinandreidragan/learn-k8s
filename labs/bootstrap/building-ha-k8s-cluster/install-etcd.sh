#!/bin/bash
set -e
set -x

source "`dirname "$1"`/config.conf"

GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=$GITHUB_URL

rm -f /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
rm -rf /tmp/etcd-download && mkdir -p /tmp/etcd-download

curl -L $DOWNLOAD_URL/$ETCD_VER/etcd-$ETCD_VER-linux-amd64.tar.gz -o /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz
tar xzvf /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1
rm -f /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz

sudo mv /tmp/etcd-download/etcd* /usr/local/bin/
rm -rf /tmp/etcd-download

# Step2: Create etcd service
etcdVMIP="$1"

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd --name $(hostname -s) \\
    --initial-advertise-peer-urls http://$etcdVMIP:2380 \\
    --listen-peer-urls http://$etcdVMIP:2380 \\
    --advertise-client-urls http://$etcdVMIP:2379 \\
    --listen-client-urls http://$etcdVMIP:2379,http://127.0.0.1:2379 \\
    --initial-cluster-token etcd-cluster-1 \\
    --initial-cluster etcd1=http://$etcd1IP:2380,etcd2=http://$etcd2IP:2380,etcd3=http://$etcd3IP:2380 \\
    --initial-cluster-state new
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Step3: Start etcd service
sudo systemctl daemon-reload
sudo systemctl enable --now etcd