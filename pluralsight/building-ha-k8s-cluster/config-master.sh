#!/bin/bash
set -e
set -x

source "`dirname "$1"`/config.conf"

cat <<EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
controlPlaneEndpoint: "$haproxyIP:6443"
networking:
  podSubnet: "192.168.0.0/16"
etcd:
  external:
    endpoints:
      - http://$etcd1IP:2379
      - http://$etcd2IP:2379
      - http://$etcd3IP:2379
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "$haproxyIP"
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

# kubeadm init command
sudo kubeadm init --config kubeadm-config.yaml --ignore-preflight-errors=all --upload-certs

# get node status
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes

# install calico
sudo kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/$CALICO_VERSION/manifests/calico.yaml