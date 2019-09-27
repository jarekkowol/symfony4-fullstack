.DEFAULT_GOAL := help
.PHONY: build up

help:
	@echo "...help in progress..."

build:
	@docker build -t symfony-fullstack_app . && docker build -t symfony-fullstack_web -f Dockerfile.nginx --build-arg ASSET_IMAGE=symfony-fullstack_app .

up:
	@docker-compose up -d
