pwd = D:/sandbox/live-project/docker-container-security-lp

default: all

all: build lint build-site start health

build:
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder
    
    
lint:
	@echo "Lint on Dockerfile..."
	@docker run --rm -i hadolint/hadolint < Dockerfile
	@echo "Linting completed."
  

build-site:
	@echo "Building the OrgDocs Hugo site..."
	@echo $(pwd)
	@docker run --name hugo-builder --rm -it -d \
    -v $(pwd)/orgdocs:/src/ \
    -u hugo \
    lp/hugo-builder hugo        
	@echo "OrgDocs Hugo site built!"
    
    
start:
	@echo "Serving the OrgDocs Hugo site..."
	@echo $(pwd)
	@docker run --name hugo-server --rm -it -d \
    -v $(pwd)/orgdocs:/src/ \
    -u hugo \
    -p 1313:1313 \
    lp/hugo-builder hugo server -w --bind=0.0.0.0
	@echo "OrgDocs Hugo site is served!"
	@docker ps --filter name=hugo-server

health:
	@echo "Checking health of OrgDocs Hugo site..."
	@docker inspect --format='{{json .State.Health}}' hugo-server
	@echo "Health check complete!"
  
stop:
	@echo "Stopping OrgDocs Hugo site..."
	@docker stop hugo-server
	@echo "OrgDocs Hugo site stopped!"
  
.PHONY: build
