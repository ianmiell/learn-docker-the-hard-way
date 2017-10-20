CHAPTERS:=$(shell ls -d asciidoc/[1-9]*)
OUTPUT_DIR:=$(shell pwd)/output
DEPLOY_DIR:=/var/www/html/learndockerthehardway
BOOK_NAME:=learndockerthehardway

include makefiles/Makefile.constants

.PHONY: chapters $(CHAPTERS) deploy docker check_host check_container

run: clean check_host docker
	docker run -v $(CURDIR)/output:/book/output lgthw /bin/sh -c 'make all && chmod -R 777 /book/output'

docker: clean check_host
	docker build -t lgthw .

chapters: $(CHAPTERS) 

$(CHAPTERS):
	$(MAKE) -C $@

clean:
	rm -rf $(OUTPUT_DIR)/* $(DEPLOY_DIR)/*

all: clean check_container chapters

# For forcing runs
FORCE:


# deploy
ifeq ($(shell hostname),rothko)

deploy: check_host run $(DEPLOY_DIR)

$(DEPLOY_DIR): FORCE
	cp -R output/9999.learndockerthehardway.pdf output/learndockerthehardway.pdf
	cp -R output/learndockerthehardway.pdf learndockerthehardway.pdf
	cp -R output/* $(DEPLOY_DIR)
	docker commit -am 'pdf'
	docker pull --rebase
	docker push

else
deploy:
	shell hostname
	$(error not on rothko)
endif




# only run in a host
check_host:
	if [ -e /.dockerenv ]; then exit 1; fi
                                                                                                                                                                                                           
# only run in a container
check_container:
	if [ ! -e /.dockerenv ]; then exit 1; fi                                                                                                                                                               
