# How TOs

## How to Open Ports

### List all open ports

```bash
# if you don't have netstat installed run: 
#  sudo apt install net-tools
netstat -lntu
```

```bash
# same result can be obtain using `ss` tool
ss -lntu
```

### iptables

[IptablesHowTo on askubuntu](https://help.ubuntu.com/community/IptablesHowTo)
