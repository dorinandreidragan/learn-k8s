#!/bin/bash

# save iptables
sudo sh -c "iptables-save -c > /etc/iptables.rules"

# create scripts for if-pre-up.d
sudo bash -c 'cat <<EOF | sudo tee /etc/network/if-pre-up.d/iptablesload
#!/bin/sh
iptables-restore < /etc/iptables.rules
exit 0
EOF'
sudo chmod +x /etc/network/if-pre-up.d/iptablesload

# creat scripts for if-post-down.d
sudo bash -c 'cat <<EOF | sudo tee /etc/network/if-post-down.d/iptablessave
#!/bin/sh
iptables-save -c > /etc/iptables.rules
if [ -f /etc/iptables.downrules ]; then
  iptables-restore < /etc/iptables.downrules
fi
exit 0
EOF'
sudo chmod +x /etc/network/if-post-down.d/iptablessave