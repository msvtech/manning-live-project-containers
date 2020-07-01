pwd = D:/sandbox/live-project/docker-container-security-lp

default: all

all: build hado-lint dockerfile-lint build-site clair start inspect_labels health

build:
	@echo .
	@echo "============================================="
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder


hado-lint:
	@echo .
	@echo "Running hadolint on Dockerfile..."
	@docker run --rm -i hadolint/hadolint:v1.17.5-alpine < Dockerfile
	@echo "hadolint completed."

dockerfile-lint:
	@echo .
	@echo "============================================="
	@echo "Running dockerfile-lint on Dockerfile..."
	@docker run -it --rm -v ${pwd}:/root/ projectatomic/dockerfile-lint dockerfile_lint -r /root/policies/all_security_rules.yml
	@echo "dockerfile-lint completed."

build-site:
	@echo .
	@echo "============================================="
	@echo "Building the OrgDocs Hugo site..."
	@echo $(pwd)
	@docker run --name hugo-builder --rm -it -d \
    -v $(pwd)/orgdocs:/src/ \
    lp/hugo-builder hugo 
	@echo "OrgDocs Hugo site built!"


clair:
	@echo .
	@echo "============================================="
	@echo "Starting clair db...."
	@docker run --rm -p 5432:5432 -d --name db arminc/clair-db:2017-09-18
	timeout 5
	@echo "Starting clair...."
	@docker run --rm -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan:v2.0.6
	
	@echo .
	@echo "Running clair-scan...."
	@../clair-scanner -w clair_config/config.yaml --ip 192.168.86.59 lp/hugo-builder
	@echo "Clair-scan complete!"
	
	@echo .
	@echo "Stopping clair...."
	@docker stop db
	@docker stop clair
	@echo "Clair stopped!"

start:
	@echo .
	@echo "============================================="
	@echo "Serving the OrgDocs Hugo site..."
	@echo $(pwd)
	@docker run --name hugo-server --rm -it -d \
    -v $(pwd)/orgdocs:/src/ \
    -p 1313:1313 \
    lp/hugo-builder hugo server -w --bind=0.0.0.0
	@echo "OrgDocs Hugo site is served!"
	@docker ps --filter name=hugo-server

health:
	@echo .
	@echo "============================================="
	@echo "Checking health of OrgDocs Hugo site..."
	@docker inspect --format='{{json .State.Health}}' hugo-server
	@echo "Health check complete!"

inspect_labels:
	@echo "Inspecting Hugo Server Container labels..."
	@echo "maintainer set to..."
	@docker inspect --format '{{ index .Config.Labels "maintainer" }}' \
    hugo-server
	@echo "Labels inspected!"

stop:
	@echo .
	@echo "============================================="
	@echo "Stopping OrgDocs Hugo site..."
	@docker stop hugo-server
	@echo "OrgDocs Hugo site stopped!"

.PHONY: build lint con_policies sec_policies policies build \
	start health stop inspect_labels clair
