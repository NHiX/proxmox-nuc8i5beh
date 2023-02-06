On va en premier créer les repertoires dont la stack guacamole a besoin

```
mkdir -p /home/docker/appdata/guacamole/{drive,record,init,data}
```

Ensuite on déploie la stacks depuis Portainer

On se rend ensuite via ssh dans le repertoire
```
cd /home/docker/appdata/guacamole/init/
```
puis on lance la commande suivante afin d'initialiser la base de données nécessaire 
au bon fonctionnement de guacamole

```
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql
```
Une fois ceci fait, on relance la stack guacamole
puis au besoin on efface le repertoire data
```
rm -fr /home/docker/appdata/guacamole/data/
```
On peut à nouveau se connecter la WebUI de guacamole
http://192.168.1.62:8080/guacamole



