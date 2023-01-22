Installation du container LXC avec Plex et l'accélération Quicksync
dans ce cas, il s'agit du premier container LXC (101)
Dans l'exemple le serveur Proxmox a pour IP: 192.168.1.20
Partage NFS sur le serveur Proxmox: /data/
Partage NFS monter dans le container plex: /mnt/data

côté proxmox
on install en cli
```
apt install nfs-common nfs-kernel-server
```
On creera le repertoire de partage à diffuser avec
```mkdir /data/```

Une fois ceci fait on ira éditer le fichier 
```
vi /etc/exports
```
```
/data/ 192.168.1.10(rw,sync) secondeIP(rw,sync)
```
Puis on relance le service nfs-kernel-server avec
```
service nfs-kernel-server restart


https://ashu.io/blog/media-server-lxc-proxmox/#intel
Pour aider à repérer le Quicksync du CPU intel
```
ls -l /dev/dri
```

Pour les modèles de CT, se rendre Datacenter -> nomduserveurproxmox->local -> CT Modèles, cliquer sur Templates et choisir debian 11

Création sous Proxmox d'un container LXC avec ne pas oublier de décocher Conteneur non privilégié
Dans l'onglet réseau IPv4 on coche DHCP
Puis ensuite une fois celui-ci créé on se rend dans Options, puis Particularités Emboîter et NFS
pour se connecter à se container lxc-attach -n 101
```
vi /etc/pve/lxc/101.conf
```
on ajoute à la fin du fichier
```
lxc.cgroup.devices.allow: c 226:* rwm
lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
```
On enregistre, on relance le container, avec la commande reboot dans le container

Une fois connecté sur le container LXC (101 dans mon cas)
il suffit de faire les manipulations suivantes en root:
```
apt update && apt install curl gnupg

echo "deb https://downloads.plex.tv/repo/deb public main" >> /etc/apt/sources.list.d/plexmediaserver.list
```
Puis:
```
curl https://downloads.plex.tv/plex-keys/PlexSign.key | apt-key add -
```
et enfin
```
apt update && apt install plexmediaserver
```
A la fin de l'installation, vous pourrez voir la bonne prise en compte du Quicksync
```
PlexMediaServer install: PlexMediaServer-1.30.0.6486-629d58034 - Installation starting.
PlexMediaServer install: 
PlexMediaServer install: Now installing based on:
PlexMediaServer install:   Installation Type:   New
PlexMediaServer install:   Process Control:     systemd
PlexMediaServer install:   Plex User:           plex
PlexMediaServer install:   Plex Group:          plex
PlexMediaServer install:   Video Group:         input
PlexMediaServer install:   Metadata Dir:        /var/lib/plexmediaserver/Library/Application Support
PlexMediaServer install:   Temp Directory:      /tmp 
PlexMediaServer install:   Lang Encoding:       en_US.UTF-8
PlexMediaServer install:   Processor:           Intel(R) Core(TM) i3-6100 CPU @ 3.70GHz
PlexMediaServer install:   Intel i915 Hardware: Found
PlexMediaServer install:   Nvidia GPU card:     Not Found
PlexMediaServer install:  
PlexMediaServer install: Completing final configuration.
Created symlink /etc/systemd/system/multi-user.target.wants/plexmediaserver.service -> /lib/systemd/system/plexmediaserver.service.
PlexMediaServer install: PlexMediaServer-1.30.0.6486-629d58034 - Installation successful.  Errors: 0, Warnings: 0
Processing triggers for mailcap (3.69) ...
```
ensuite, connexion sur l'adresse IP:"32400/web" pour la prise en compte du nouveau serveur de contenu par Plex
```
apt install nfs-common
```
Pour tester le montage du partage NFS, depuis le container plex 
```
lxc-attach -n 101
```
Puis on lance la commande en manuel
```
mount -t nfs 192.168.1.20:/data /mnt/data
```
on déclare le partage NFS à monter dans le fichier /etc/fstab
```
192.168.1.20:/data/ /mnt/data nfs
```
puis 
```
mount -a
