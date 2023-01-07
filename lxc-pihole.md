Installation de Pihole dans un container LXC sur Proxmox


```
pveam update
pveam available --section system
```
Dans cet exemple on téléchargera une distribution Debian 11

```
pveam download local debian-11-standard_11.6-1_amd64.tar.zst
```
On vérifie le téléchargement sur Proxmox du container Debian 11 avec:

```
pveam list local
NAME                                                         SIZE  
local:vztmpl/debian-11-standard_11.3-1_amd64.tar.zst         117.51MB
```

Création d'un container LXC dans Proxmox
Le fichier de configuration:
```
cat /etc/pve/lxc/104.conf 

arch: amd64
cores: 1
features: nesting=1
hostname: pihole
memory: 512
net0: name=eth0,bridge=vmbr0,firewall=1,hwaddr=2E:83:AB:5B:DF:32,ip=dhcp,type=veth
ostype: debian
rootfs: local-lvm:vm-104-disk-0,size=5G
swap: 512
unprivileged: 1
```

une fois connecté en root sur le container:

```
apt update && apt install -y curl &&
curl -sSL https://install.pi-hole.net | bash
```

Ensuite on se connecte en WebUI sur http://adresseIPduContainerPiHole/admin
On renseigne sur les differents appareils le DNS qui sera l'adresse IP du container PiHole

