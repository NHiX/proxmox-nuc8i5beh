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

## Stopper le container nginx-docker
```
docker stop nginx-docker
```
puis 
```
docker rm nginx-docker
```
Pour supprimer l'image du container

## Mettre à jour le container
```
docker pull nginx-docker
```
Va télécharger de façon automatique si le container a été mis à jour depuis le hub.docker.com

## Voir les containers lancés sur la machine
Il suffit de rentrer la commande 
```
docker ps
```
On devrait obtenir cette affichage:
```
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
d8ce7caf400a   ubuntu        "bash"     5 seconds ago    Exited (0) 3 seconds ago              adoring_lalande
04c652b113d1   hello-world   "/hello"   12 seconds ago   Exited (0) 11 seconds ago             determined_leakey
40d35efca128   nginx:latest  "/docker-entrypoint.…"  11 minutes ago Up 11 minutes 0.0.0.0:8080->80/tcp nginx-docker
```
NB: On peut lancer la commande docker ps -a afin de voir tout les containers même ceux stoppés  

On remarque dans la colonne NAMES, les noms fournit au hasard par docker, si on souhaite définir un nom spécifique
pour un container, il faudra utiliser le paramétre --name nomducontainer, on peut voir aussi le port exposé et bindé
## Monitorer les containers
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

On peut aussi voir les logs du container
```
docker logs nginx-docker -f
```
Le paramétre -f a le même effet que la commande tail -f

## Monter un répertoire (binder)
on va créer un fichier index.html avec la commande:
```
echo "Test" > $HOME/index.html
```
ensuite on lancera un docker ps -a afin de vérifier que le container appelé nginx-docker ne soit plus lancé
```
docker stop nginx-docker && docker rm nginx-docker
```
On relance à nouveau le container avec le montage du repertoire de l'utilisateur
```
docker run -d -p 8080:80 -v /home/$USER:/usr/share/nginx/html --name nginx-docker nginx
```
On va monter le repertoire du container /usr/share/nginx/html dans le repertoire utilisateur, là où le fichier index.html sera chargé
on va pouvoir le vérifier avec:
```
docker exec -it nginx-docker bash
```
Puis une fois dans le container, on lance la commande:
```
curl localhost
```
Il devrait retourner le contenu du fichier index.html


## Faire le ménage dans les containers sur la machine
```
docker container prune
```
Répondre Y à la question afin d'effacer de la machine toutes les images des containers téléchargés.


### Ce qu'on sait faire avec docker pour le moment

lancer un container

entrer dans un container

rediriger un port d'un container

nommer un container

executer une commande qui se trouve dans un container

choisir la version du container à lancer

voir les containers présents sur la machine

executer un container en arrière plan

Binder ou monter un repertoire 

Effacer tous les containers de la machine

Voir les journaux du container

## Aller plus loin avec docker
Inspecter la configuration d'un container
```
docker inspect nginx-docker
```

