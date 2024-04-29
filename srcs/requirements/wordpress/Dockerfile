FROM debian:buster

# Met à jour les paquets et installe les dépendances
RUN apt update -y && apt-get -y install wget \
	&& apt-get install -y php7.3 php-fpm php-mysql	mariadb-client \
	sendmail

# Création des répertoires
RUN wget https://fr.wordpress.org/wordpress-6.4.3-fr_FR.tar.gz -P /var/www \
	&& cd /var/www && tar -xzf wordpress-6.4.3-fr_FR.tar.gz && rm wordpress-6.4.3-fr_FR.tar.gz

# Modification des droits
RUN chown -R root:root /var/www/wordpress

# Copie de la configuration PHP-FPM
COPY conf/www.conf /etc/php/7.3/fpm/pool.d

# Installation de WP-CLI
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&&  mv wp-cli.phar /usr/local/bin/

# Copie du script d'initialisation et le rend exécutable
COPY tools/script.sh /usr/local/bin/script.sh

# Rend le script exécutable
RUN chmod +x /usr/local/bin/script.sh

# Création des répertoires
RUN mkdir -p /run/php

# Expose le port 9000
EXPOSE 9000

# Définit le point d'entrée du conteneur
ENTRYPOINT ["bash", "./usr/local/bin/script.sh"]

# CMD ["php-fpm81", "--nodaemonize"]

# Ce Dockerfile définit les étapes nécessaires pour créer un conteneur Docker prêt à exécuter un environnement WordPress avec PHP-FPM. Voici ce que chaque étape fait :

# 	1. `FROM debian:buster`: Utilise l'image Debian Buster comme base pour le conteneur.
# 	2. `RUN apt update -y && apt-get -y install wget \ ...`: Met à jour les paquets, installe wget et les dépendances PHP nécessaires pour WordPress (`php7.3`, `php-fpm`, `php-mysql`, `mariadb-client`).
# 	3. `RUN wget https://fr.wordpress.org/wordpress-6.4.3-fr_FR.tar.gz -P /var/www \ ...`: Télécharge WordPress en français, le décompresse dans `/var/www` et nettoie le fichier d'installation.
# 	4. `RUN chown -R root:root /var/www/wordpress`: Modifie les droits du répertoire WordPress pour que l'utilisateur `root` en soit le propriétaire.
# 	5. `COPY conf/www.conf /etc/php/7.3/fpm/pool.d`: Copie un fichier de configuration pour PHP-FPM dans le répertoire approprié.
# 	6. `RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \ ...`: Télécharge et installe WP-CLI (WordPress Command Line Interface) dans le conteneur.
# 	7. `COPY tools/script.sh /usr/local/bin/script.sh`: Copie un script d'initialisation dans le conteneur.
# 	8. `RUN chmod +x /usr/local/bin/script.sh`: Rend le script d'initialisation exécutable.
# 	9. `RUN mkdir -p /run/php`: Crée un répertoire pour stocker les fichiers de socket PHP.
# 	10. `EXPOSE 9000`: Indique que le conteneur expose le port 9000 utilisé par PHP-FPM.
# 	11. `ENTRYPOINT ["bash", "./usr/local/bin/script.sh"]`: Définit le point d'entrée du conteneur comme étant l'exécution du script d'initialisation avec Bash.
# 	12. `CMD ["php-fpm81", "--nodaemonize"]`: Définit la commande par défaut à exécuter dans le conteneur comme PHP-FPM version 8.1 en mode sans démonisation.

# En résumé, ce Dockerfile configure un environnement avec PHP, WordPress, WP-CLI et PHP-FPM prêt à être utilisé pour héberger des sites WordPress dans un conteneur Docker.