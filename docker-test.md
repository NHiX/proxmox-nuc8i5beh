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
docker run -d -p 80:80 --name nginx-docker nginx:latest
```
explication de la commande:  
lancement du serveur web nginx, qui sera accessible sur localhost (127.0.0.1) port 80

l'option -p permet de binder le port du container avec celui sur lequel il sera accessible  
-p externe:interne  
-d mode daemon, c'est à dire que le container continu à s'éxécuter en arrière plan  


le --name permet de nommer le container, il apparaitra comme ça sous son nom  
quand on fera un docker ps

le nginx:latest, on va chercher le container 

nginx dans sa dernière version publiée sur le hub.docker.com
