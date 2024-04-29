FROM debian:buster

# Met à jour les paquets et installe Nginx et OpenSSL
RUN apt update -y && apt install -y nginx openssl

# Création des répertoires
RUN mkdir -p /etc/nginx/ssl && mkdir -p /run/nginx

# Génération du certificat SSL auto-signé
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key \
	-subj "/C=CA/ST=QC/L=Quebec/O=42/OU=42/CN=fbouchar.42.fr/UID=login"

# Copie de la configuration Nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Rend accessible le port 443
EXPOSE 443

# Point d'entrée du conteneur Nginx
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

# Ce Dockerfile crée un conteneur à partir de l'image Debian Buster et y installe Nginx et OpenSSL. Voici ce qu'il fait :

# 	1. **Installation de Nginx et OpenSSL** : Met à jour les paquets, puis installe Nginx et OpenSSL.
# 	2. **Création des répertoires** : Crée les répertoires `/etc/nginx/ssl` pour stocker les certificats SSL et `/run/nginx` pour les fichiers de log de Nginx.
# 	3. **Génération du certificat SSL** : Utilise OpenSSL pour générer un certificat SSL auto-signé (`inception.crt`) et une clé privée (`inception.key`). Il spécifie également les informations relatives au sujet du certificat comme le pays (C), l'État (ST), la localité (L), l'organisation (O), l'unité organisationnelle (OU), le nom commun (CN), et l'identifiant unique (UID).
# 	4. **Copie de la configuration Nginx** : Copie le fichier de configuration Nginx (`conf/nginx.conf`) dans le conteneur, remplaçant ainsi la configuration par défaut.
# 	5. **Exposition du port 443** : Indique que le conteneur doit exposer le port 443 pour les connexions HTTPS.
# 	6. **Point d'entrée Nginx** : Définit Nginx comme le point d'entrée du conteneur avec l'option `-g "daemon off;"` pour exécuter Nginx en mode démon sans se détacher, ce qui est utile dans un environnement Docker.

# En résumé, ce Dockerfile crée un conteneur Nginx avec un certificat SSL auto-signé, une configuration personnalisée, et le configure pour écouter les connexions HTTPS sur le port 443.