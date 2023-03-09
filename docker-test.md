# Docker expérience

Après installation de docker, il suffit de tester par une image 

## Lancement d'un premier container
```
docker run hello-world
```
explication de la commande:
run, on va demander à docker de "lancer" le container hello-world,
c'est un container qui va juste afficher un message

Une fois le message de bienvenue qui apparait on pourra procéder
à des exercices plus complexes. Comme celui proposé dans le message
de ce container...

## Lancement d'un second container se connecter dans un container ubuntu
```
docker run -it ubuntu bash
```
On se retrouve donc à télécharger ce container car celui-ci n'existe pas encore 
sur notre machine, puis apparait un shell bash, nous nous trouvons donc bien
dans le container ubuntu. 

root@c453t23:/#  

On peut taper n'importe quelle commande comme si on se trouve sur ubuntu
Pour sortir du container, il suffit d'entrer exit
Analyse des paramètres passés à docker

-it signifie, mode interactif où le prompt sera dans le container ubuntu. 

ubuntu lancement du container ubuntu, par défaut avec le tag latest. 

bash binaire à lancer quand on se connecte dans ce container. 

## Voir les containers lancés sur la machine


## Lancement d'un troisième container exemple pour un serveur web
```
docker run -d -p 8080:80 --name nginx-docker nginx:latest
```
explication de la commande:  
lancement du serveur web nginx, qui sera accessible sur localhost (127.0.0.1) port 8080

l'option -p permet de binder le port du container avec celui sur lequel il sera accessible  
-p externe:interne  
-d mode daemon, c'est à dire que le container continu à s'éxécuter en arrière plan  


le --name permet de nommer le container, il apparaitra comme ça sous son nom  
quand on fera un docker ps

le nginx:latest, on va chercher le container 

nginx dans sa dernière version publiée sur le hub.docker.com

## Se connecter au container pendant qu'il est lancé
On va se connecter au container nginx-docker avec la commande:
```
docker exec -it nginx-docker /bin/bash
```
Une fois dans ce container, pour tester le bon fonctionnement de celui-ci
On peut executer
```
curl localhost
```
On obtient:
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
On sait que le service nginx fonctionne parfaitement

## Monitorer les containers
Il suffit de rentrer la commande 
```
docker ps -a
```
On devrait obtenir cette affichage:
```
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
d8ce7caf400a   ubuntu        "bash"     5 seconds ago    Exited (0) 3 seconds ago              adoring_lalande
04c652b113d1   hello-world   "/hello"   12 seconds ago   Exited (0) 11 seconds ago             determined_leakey
40d35efca128   nginx:latest  "/docker-entrypoint.…"  11 minutes ago Up 11 minutes 0.0.0.0:8080->80/tcp nginx-docker
```
On remarque dans la colonne NAMES, les noms fournit au hasard par docker, si on souhaite définir un nom spécifique
pour un container, il faudra utiliser le paramétre --name nomducontainer, on peut voir aussi le port exposé et bindé
Pour aller plus loin, il existe la commande
```
docker stats
```
On obtient:
```
CONTAINER ID   NAME           CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O     PIDS
40d35efca128   nginx-docker   0.00%     2.617MiB / 3.832GiB   0.07%     3.61kB / 0B   0B / 16.4kB   3
```
On remarque ici les informations sont très differentes d'un docker ps, ceux qui rend cette commande complémentaire à docker ps -a
On quitte cette commande avec un CTRL+C

### Ce qu'on sait faire avec docker pour le moment

lancer un container

entrer dans un container

rediriger un port d'un container

nommer un container

executer une commande qui se trouve dans un container

choisir la version du container à lancer

voir les containers présents sur la machine

executer un container en arrière plan
