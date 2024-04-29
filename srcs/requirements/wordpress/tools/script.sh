#!bin/bash

sleep 30

echo "->Commencons la configuration de WordPress."
if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	wp-cli.phar config create --allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_PASSWORD \
		--dbhost=mariadb:3306 \
		--path="/var/www/wordpress"

  echo "->wp-config.php créé"
	wp-cli.phar core install --allow-root \
		--url='https://fbouchar.42.fr' \
        --title="Inception" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_EMAIL" \
        --path="/var/www/wordpress"

  echo "->Installation de WordPress terminée"

  echo "->Création de l'utilisateur $WP_USER"
	wp-cli.phar user create --allow-root\
    	"$WP_USER" \
        "$WP_USER_EMAIL" \
		--role=author \
        --user_pass="$WP_USER_PASSWORD" \
        --path="/var/www/wordpress"

	echo "->Fin de la configuration de WordPress"

else
	echo "->La configuration de WordPress existe déjà. Sautons la configuration."

fi

echo "->Démarrage de php-fpm"
echo "->WordPress est prêt à être utilisé."
/usr/sbin/php-fpm7.3 -F


# Ce script shell doit être exécuté au démarrage du conteneur WordPress.
# Il doit effectuer les tâches suivantes :

	# 1. Attendez 30 secondes pour permettre aux autres applications de bien démarrer.
	# 2. Vérifiez si le fichier `wp-config.php` de WordPress existe dans le répertoire `/var/www/wordpress`. Si ce n'est pas le cas :
	#    - Utilisez `wp-cli.phar`(un outil en ligne de commande pour WordPress) pour créer le fichier `wp-config.php` avec les informations de la base de données (dbname, dbuser, dbpass, dbhost) et le chemin d'installation de WordPress.
	#    - Installez WordPress en utilisant `wp-cli.phar` avec les paramètres spécifiés (URL, titre, utilisateur administrateur, mot de passe administrateur, email administrateur) et le chemin d'installation de WordPress.
	#    - Créez un nouvel utilisateur WordPress avec un rôle "author" en utilisant `wp-cli.phar` avec les informations fournies (nom d'utilisateur, email, mot de passe) et le chemin d'installation de WordPress.
	# 3. Si le fichier `wp-config.php` existe déjà, affichez un message indiquant que la configuration de WordPress existe déjà et sautez la configuration.
	# 4. Démarrez PHP-FPM version 7.3 en mode foreground pour exécuter WordPress.
	# 5. Affichez un message indiquant que WordPress est prêt à être utilisé.

# Ce script shell permet de configurer WordPress lors du démarrage du conteneur. Il crée le fichier `wp-config.php` s'il n'existe pas déjà, installe WordPress et crée un nouvel utilisateur WordPress. Il démarre ensuite PHP-FPM pour exécuter WordPress.