start: setup
	cd srcs \
	&& docker compose up --build -d


setup: ## Creation des dossiers de données
	sudo mkdir -p /home/fbouchar/data
	sudo mkdir -p /home/fbouchar/data/mariadb
	sudo mkdir -p /home/fbouchar/data/wordpress


up: ## Lance Inception
	cd srcs && docker compose up -d


down: ## Arrete Inception
	cd srcs && docker compose down -v


build: ## Fabrique les images docker
	cd srcs && docker compose build


status: ## Affiche les containers, images et volumes
	docker ps && docker images && docker volume ls


reload: build up ## Redemarre Inception


logs: ## Affiche les logs
	cd srcs && docker compose logs -f


prune: ## Nettoie les images, volumes et containers
	docker system prune --all --force


clean: down ## Arrête et supprime les containers
	cd srcs \
	&& docker image prune --force \
	&& docker volume prune --force


cleanvol: ## Enleve les volumes persistants
	sudo rm -rf /home/fbouchar/data


fclean: down clean prune cleanvol ## Nettoie tout

re: fclean start

help:
	@ awk 'BEGIN {FS = ":.*##";} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

db :
	docker exec -it MariaDB mysql -u root -p

# #password = DB_ROOT_PASSWORD
# show databases;
# use fbouchar_db;
# show tables;
# select * from wp_users;

.PHONY: start setup up down build status reload logs prune clean cleanvol fclean re help