
IMAGE  = observer
REPO   = jflatow/$(IMAGE)
RDP    = 9222
LRDP   = 9223
ENV    = -e RDP=$(RDP) -e LRDP=$(LRDP)
EXPOSE = -p $(RDP):$(RDP)

EXAMPLE = https://api.observablehq.com/@jflatow/headless-observable.js?key=7d7a86c7b4aefbef

.PHONY: build image rinse

build:
	npm install

image:
	docker build -t $(IMAGE) .

rinse:
	docker kill $(shell docker ps --filter "status=created" -q) || true
	docker rmi -f $(shell docker images --filter "dangling=true" -q)

run: NOTEBOOK = $(EXAMPLE)
run:
	docker run --rm -it $(ENV) $(EXPOSE) -e NOTEBOOKS=$(NOTEBOOK) $(IMAGE)

run-debug:
	docker run --rm -it $(ENV) $(EXPOSE) --entrypoint /bin/sh $(IMAGE)

run-hyper: NAME = my-observer
run-hyper: NOTEBOOK = $(EXAMPLE)
run-hyper:
	hyper run -d --name $(NAME) $(ENV) $(EXPOSE) -e NOTEBOOKS=$(NOTEBOOK) $(REPO)

remsh:
	docker exec -it $(shell docker ps --filter "ancestor=observer" -q) /bin/sh
