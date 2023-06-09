IMAGE:=spark-generic
CONTAINER:=spark-master-container

all: stop build start

build:
	docker build -t $(IMAGE) .

start:
	docker compose up -d

stop:
	docker compose down --remove-orphans

bash:
	docker exec -it $(CONTAINER) bash

token:
	@echo $(shell docker exec -it $(CONTAINER) jupyter lab list | grep -oP "(?<=token=).*(?=::)")
