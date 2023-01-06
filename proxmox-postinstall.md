# Installation Proxmox 7.3
DNS faire attention qu'il soit bien défini sur l'IP de la BOX (souvent 192.168.1.1) et non sur le 127.0.0.1

Faire cette commande connecté en root sur la machine proxmox
```
sed -i.bak 's/notfound/active/g' /usr/share/perl5/PVE/API2/Subscription.pm && systemctl restart pveproxy.service
```
Il faudra refaire cette commande à chaque mise à jour de proxmox

## Attention à la version de debian !
Concernant les pkgs les mises à jour
```
vi /etc/apt/sources.list.d/pve-enterprise.list
```
commenter la première ligne avec #
```
#deb https://enterprise.proxmox.com/debian/pve  bullseye pve-enterprise
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
```
## Pour profiter du VirGL (accélération graphique)
```
apt update && apt full-upgrade
apt install htop mc libgl1 libegl1 nfs-common nfs-kernel-server
```
configurer le partage NFS sur l'hôte (Proxmox ?)
```
vi /etc/exports
```

vi /etc/fstab pour configurer le montage des partitions NFS distants


## Pour lister les containers LXC disponibles sous Proxmox
pveam available --section system
---
pveam download local ladistributionvoulu
---
