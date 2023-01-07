Installation de Pihole dans un container LXC sur Proxmox

Création d'un container LXC dans Proxmox
une fois connecté en root sur le container:

```
apt update && apt install -y curl &&
curl -sSL https://install.pi-hole.net | bash
```

Ensuite on se connecte en WebUI sur http://adresseIPduContainerPiHole/admin
On renseigne sur les differents appareils le DNS qui sera l'adresse IP du container PiHole

