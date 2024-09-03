help: ## Show this help.
	@# Optionally add 'sort' before 'awk'
	@grep -E '^[^_][a-zA-Z_\/\.%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
.PHONY: help

proj_dir := "project"
ver := $(shell grep "config/version" <"$(proj_dir)/project.godot" | cut -d'"' -f2)
release := $(shell echo $(ver) | tr '.' '-')

version: ## Display the project version that will be produced by 'make build'
	@:
	$(info $(ver))
	$(info $(desc))
.PHONY: version

build:  ## Create Linux executable in dist/
	godot --quiet --headless --export-release 'Linux/X11' dist/Missile-Commander-v$(release)
	godot --quiet --headless --export-release 'Windows Desktop' dist/Missile-Commander-v$(release).exe
.PHONY: release

clean:  ## Remove built and intermediate files
	echo rm -rf dist/*
.PHONY: clean

