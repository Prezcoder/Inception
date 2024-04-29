#!/bin/bash

# Sortie en cas d'erreur
set -e

main() {
	initialize_database
}

initialize_database() {
	echo "->Commencons l'initialisation de la base de données."
	# Verifier si la base de données existe déjà
	if [ -d "/var/lib/mysql/${DB_NAME}" ]; then
		echo "La base de donnée ${DB_NAME} existe déjà. Sautons la confiuguration."
	else
		50-server
		mariadb
		create_db_root
		close_mariadb
	fi
	echo "->L'initialisation de la base de données est terminée."
	mariadb_safe
}

50-server() {
	if ! grep -q "^port\s*=\s*3306" /etc/mysql/mariadb.conf.d/50-server.cnf; then
		echo "port = 3306" >> /etc/mysql/mariadb.conf.d/50-server.cnf
	fi

	if ! grep -q "bind-address = 0.0.0.0" /etc/mysql/mariadb.conf.d/50-server.cnf; then
		sed -i 's/bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
	fi
}

mariadb() {
	echo "->Démarrage du serveur MariaDB."
	mkdir -p /var/run/mysqld
	chown -R mysql:mysql /var/run/mysqld
	service mysql start
	sleep 7
}

create_db_root() {
	echo "->Création de la base de données et de l'utilisateur root."
	SQL_COMMANDS="${DB_NAME}.sql"
	echo "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;" > "$SQL_COMMANDS"
	echo "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'localhost' IDENTIFIED BY '${DB_PASSWORD}';" >> "$SQL_COMMANDS"
	echo "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;" >> "$SQL_COMMANDS"
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';" >> "$SQL_COMMANDS"
	echo "FLUSH PRIVILEGES;" >> "$SQL_COMMANDS"
	cat "$SQL_COMMANDS"
	mysql < "$SQL_COMMANDS" || { echo "ERREUR--L'initialisation de la base de donnée à échoué."; exit 1; }
}

close_mariadb() {
	echo "->Fermeture du serveur MariaDB."
	mysqladmin -u root -p"$DB_ROOT_PASSWORD" -S /var/run/mysqld/mysqld.sock shutdown
	sleep 7
}

mariadb_safe() {
	echo "->Démarrage du serveur MariaDB en mode sécurisé avec l'utilisateur root mis à jour."
	exec mysqld_safe
}

main

# Ce script Bash est conçu pour initialiser une base de données MariaDB. Voici ce qu'il fait :

# 1. Vérifie si la base de données existe déjà. Si oui, il saute la configuration.
# 2. S'il n'existe pas, il effectue les étapes suivantes :
#    - Configure le fichier de configuration de MariaDB pour spécifier le port et la liaison IP.
#    - Démarre le serveur MariaDB.
#    - Crée une base de données, un utilisateur et définit les privilèges d'accès.
#    - Change le mot de passe de l'utilisateur root.
#    - Redémarre le serveur MariaDB en mode sécurisé.

# En résumé, il configure et démarre MariaDB, crée une base de données et un utilisateur avec les privilèges nécessaires, puis redémarre MariaDB en mode sécurisé.