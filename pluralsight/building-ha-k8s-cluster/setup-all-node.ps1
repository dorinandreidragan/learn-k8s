function setupNode($nodeIp) {
    scp $PSScriptRoot/install* $PSScriptRoot/setup* $PSScriptRoot/config* vagrant@${nodeIp}:~/.
    ssh vagrant@$nodeIp "chmod +x install* setup* config*; ./setup-node.sh"
}

function configMaster($masterIp) {
    scp $PSScriptRoot/config* vagrant@${masterIp}:~/.
    ssh vagrant@$masterIp "chmod +x config*; ./config-master.sh"
}

# setup all nodes

# masters
setupNode("192.168.1.21")
setupNode("192.168.1.22")
setupNode("192.168.1.21")

# workers
setupNode("192.168.1.32")
setupNode("192.168.1.33")
setupNode("192.168.1.33")

# config first master
configMaster("192.168.1.21")