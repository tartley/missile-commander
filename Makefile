help: ## Show this help.
	@# Optionally add 'sort' before 'awk'
	@grep -E '^[^_][a-zA-Z_\/\.%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
.PHONY: help

version := $(shell grep <project.godot "config/version" | cut -d'"' -f2 | tr '.' '-')

release:  ## Create Linux executable in dist/
	godot --quiet --headless --export-release 'Linux/X11' dist/Missile-Commander-v$(version)

clean:  ## Remove dist/*
	rm -rf dist/*

