IMAGE=spark-generic
CONTAINER=spark-master-container

all:
	docker compose up -d

build:
	docker build -t $(IMAGE) .

stop:
	docker compose down --remove-orphans

bash:
	docker exec -it $(CONTAINER) bash

token:
	@echo $(shell docker exec -it $(CONTAINER) jupyter lab list | grep -oP "(?<=token=).*(?=::)")

renew: stop build all
