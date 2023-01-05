# Doit etre lance en root après chaque mise à jour de Proxmox
sed -i.bak 's/notfound/active/g' /usr/share/perl5/PVE/API2/Subscription.pm && systemctl restart pveproxy.service
# Ajout du dépot pve-no-subscription
echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" >> /etc/apt/sources.list.d/pve-enterprise.list
# Installation sur Proxmox du necessaire pour le partage NFS et le client Spice 
apt update && apt install -y htop mc libgl1 libegl1 nfs-common nfs-kernel-server
