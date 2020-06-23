default: build

build:
	@echo "Run  Static Analysis on Dockerfile..."
  @docker run --rm -i hadolint/hadolint < Dockerfile
	
  @echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .	
  @echo "Hugo Builder container built!"  
	@docker images lp/hugo-builder
  
	@docker run --name hugo-builder --rm -d -p 1313:1313 -v D:/sandbox/live-project/docker-container-security-lp/orgdocs:/src/ lp/hugo-builder
  
.PHONY: build
