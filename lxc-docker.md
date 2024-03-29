Création d'un container LXC Debian pour Docker

Nested et NFS sont à activer dans Options

apt update && apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common

Ajout du dépôt officiel de docker:

```
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
```
```
apt update && apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin nfs-common
```
On va ensuite tester la bonne récupération d'un container de test
```
docker run hello-world
```
Si besoin:
```
systemctl enable docker --now
```
Montage NFS depuis la machine proxmox 192.168.1.20
Dans le container docker
le contenu du fichier /etc/fstab en supposant qu'on partage le repertoire depuis Proxmox /data vers le container docker dans /srv/data

192.168.1.20:/data      /srv/data       nfs     defaults        0 0

Concernant OpenVPN pour le container
On va ajouter les 2 lignes au fichiers de configuration du container LXC
```
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net dev/net none bind,create=dir
```

Si besoin, on peut lancer la commande suivante depuis la machine proxmox, pas du container
```
chown 100000:100000 /dev/net/tun
```
Pour "tester" la connexion au VPN, on lancera depuis le container rutorrent par exemple la commande:

```
docker exec -it rutorrent curl ifconfig.me
```
L'adresse IP retournée doit être differente de celle qu'on obtient en local depuis le container LXC
avec la commande:

```
curl ifconfig.me
```

installation de lazydocker dans le container
dans le .bashrc de l'utilisateur root

```
echo "alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v /root/config:/.config/jesseduffield/lazydocker lazyteam/lazydocker'" >> ~/.bashrc
```

```
sources .bashrc
```
Voir la page https://pve.proxmox.com/wiki/OpenVPN_in_LXC
