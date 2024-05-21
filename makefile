-include .creds

BASEIMAGE := xycarto/qgis-tiler
IMAGE := $(BASEIMAGE):2024-05-15

RUN ?= docker run -it --rm  \
	--user=$$(id -u):$$(id -g) \
	--shm-size=10.24gb \
	-e DISPLAY=$$DISPLAY \
	--env-file .creds \
	-e RUN= -v $$(pwd):/work \
	-w /work $(IMAGE)

PHONEY: 

##### MAKE TILES #####
# time make coverage epsg=3857 qgis="qgis/world-elevation.qgz" minzoom=0 maxzoom=2 version=v1
coverage:
	$(RUN) bash src/coverage.sh $(epsg) $(qgis) $(minzoom) $(maxzoom) $(version)

raster-tiles:
	$(RUN) python3 src/raster-tiler.py  $(matrix) $(zoom) $(qgis) $(coverage) $(version) $(cores)

vector-tiles:
	$(RUN) bash src/vector-tiles.sh
	

##### DOCKER #####
test-local: Dockerfile
	docker run -it --rm  \
	--user=$$(id -u):$$(id -g) \
	-e DISPLAY=$$DISPLAY \
	--env-file .creds \
	-e RUN= -v$$(pwd):/work \
	-w /work $(IMAGE)
	bash
	
docker-local: Dockerfile
	docker build --tag $(BASEIMAGE) - < $<  && \
	docker tag $(BASEIMAGE) $(IMAGE)

docker-push: Dockerfile
	echo $(DOCKER_PW) | docker login --username xycarto --password-stdin
	docker build --tag $(BASEIMAGE) - < $<  && \
	docker tag $(BASEIMAGE) $(IMAGE) && \
	docker push $(IMAGE)

docker-pull:
	docker pull $(IMAGE)