sudo swapoff -a

# install containerd
sudo modprobe overlay
sudo modprobe br_netfilter

sudo bash -c 'cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF'

# Setup required sysctl params, these persist across reboots.
sudo bash -c 'cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF'

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd
sudo apt-get update
sudo apt-get install -y containerd

# Create a containerd configuration file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Set the cgroup driver for containerd to systemd which is required for the kubelet.

# At the end of this section
#   [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
# Add these two lines, indentation matters.
#     [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
#       SystemCgroup = true
sudo sed -i "/SystemdCgroup =/ s/= .*/= true/" /etc/containerd/config.toml

# Restart containerd with the new configuration
sudo systemctl restart containerd

# Install Kubernetes packages - kubeadm, kubelet and kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add Google's apt repository gpg key
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF'

# Update the package list and use apt-cache policy to insepct versions available in the repository
sudo apt-get update
apt-cache policy kubelet | head -n 20

VERSION=1.22.4-00
sudo apt-get install -y \
        kubelet=$VERSION \
        kubeadm=$VERSION \
        kubectl=$VERSION

sudo apt-mark hold \
        kubelet \
        kubeadm \
        kubectl \
        containerd

# 1 - systemd Units
# Check the status of our kubelet and our container runtime, containerd.
# The kubelet will enter a crashloop until a cluster is created or the node is joined to an existing cluster.
sudo systemctl status kubelet.service
sudo systemctl status containerd.service

# Ensure both are set to start when the system starts up.
sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service
