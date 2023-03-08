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
à des exercices plus complexes.

## Lancement d'un second container pour un serveur web
```
docker run -p 80:80 nginx:latest
```
explication de la commande:
lancement du serveur web nginx, qui sera accessible sur localhost (127.0.0.1) port 80
l'option -p permet de binder le port du container avec celui sur lequel il sera accessible
-p externe:interne 
