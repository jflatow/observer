
IMAGE  = observer
RDP    = 9222
LRDP   = 9223
ENV    = -e RDP=$(RDP) -e LRDP=$(LRDP)
EXPOSE = -p $(RDP):$(RDP)

.PHONY: build image rinse

build:
	npm install

image:
	docker build -t $(IMAGE) .

rinse:
	docker kill $(shell docker ps --filter "status=created" -q) || true
	docker rmi -f $(shell docker images --filter "dangling=true" -q)

run:
	docker run --rm -it $(ENV) $(EXPOSE) observer

run-debug:
	docker run --rm -it $(ENV) $(EXPOSE) --entrypoint /bin/sh observer

remsh:
	docker exec -it $(shell docker ps --filter "ancestor=observer" -q) /bin/sh
