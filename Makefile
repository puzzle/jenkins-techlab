.PHONY: help

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := local_env/docker-compose.yml

build: ## Build or rebuild services
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build

up: ## Create and start containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up

start: ## Create and start containers. Detached mode: Run containers in the background
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d

setup: ## Build or rebuild services and create and start containers in detached mode
	@$(MAKE) build
	@$(MAKE) start

stop: ## Stop services
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop

restart: ## Stop services and create and start containers in detached mode
	@$(MAKE) stop
	@$(MAKE) start

bash: ## Execute bash in a running container (c=jenkins|jenkins_slave_docker|docker|rocketchat|mongo|mongo-init-replica|hubot)
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) exec $(c) /bin/bash

ps: ## List containers
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps

logs: ## View output from containers with following the log output. Shows the last 100 lines of the tail
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f 

clean: ## Stop and remove resources and remove named volumes declared in the `volumes` section of the Compose file
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v
