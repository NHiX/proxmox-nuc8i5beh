Création de la VM Debian SID à partir d'un ISO de Testing

On installera juste les outils systèmes et SSH
Puis au reboot après l'installation, on ira éditer le fichier:
```
vi /etc/apt/sources.list
```

On lancera la commande dans vi(m)
```
:%s/bullseye/sid/g
```
On commentera les dépôts security
On ajoutera les dépôts non-free et contrib
```
:%s/main$/main non-free contrib/g
```
on sauvegarde le fichier sources.list
puis on lancera
```
apt update && apt full-upgrade && tasksel
```
Une fois dans tasksel on pourra selectionner l'environnement de bureau à installer
ne pas oublier ensuite de rebooter la VM
```
reboot
```
