FROM debian:buster

# Met à jour les paquets et installe MariaDB
RUN apt-get update -y \
	&& apt-get install mariadb-server -y \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# Copie le script de configuration et le rend exécutable
COPY tools/script.sh /usr/local/bin
RUN chmod +x /usr/local/bin/script.sh

# Rend accessible le port 3306
EXPOSE 3306

# Définit le volume pour les données de MariaDB
VOLUME ["/var/lib/mysql"]

# Définit le point d'entrée du conteneur
ENTRYPOINT ["/usr/local/bin/script.sh"]

# Ce Dockerfile définit un conteneur basé sur Debian Buster qui :

# 	1. Met à jour les paquets, installe MariaDB, et nettoie le cache des paquets installés.
# 	2. Copie un script de configuration (`tools/script.sh`) dans le répertoire `/usr/local/bin` du conteneur et le rend exécutable.
# 	3. Rend accessible le port 3306 du conteneur pour MariaDB.
# 	4. Définit un volume `/var/lib/mysql` pour stocker les données de MariaDB.
# 	5. Définit le point d'entrée du conteneur pour exécuter le script `/usr/local/bin/script.sh` lorsqu'il démarre.
	
# En résumé, ce Dockerfile crée un conteneur MariaDB prêt à l'emploi en installant le serveur MariaDB, en configurant un script 
# d'initialisation, en exposant le port 3306, en configurant un volume pour les données, et en définissant le point d'entrée pour 
# lancer le script d'initialisation lors du démarrage du conteneur.