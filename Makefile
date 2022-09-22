build:
	docker-compose build
run:init
	docker-compose up -d
stop:
	docker-compose down
init:
	docker volume create kafkadata
	docker volume create pgdata
	docker volume create zookeeperdata
