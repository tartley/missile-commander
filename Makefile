help: ## Show this help.
	@# Optionally add 'sort' before 'awk'
	@grep -E '^[^_][a-zA-Z_\/\.%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
.PHONY: help

proj_dir := "project"
ver := $(shell grep "config/version" <"$(proj_dir)/project.godot" | cut -d'"' -f2)
# Version with dots replaced, for use in build output filenames
release := $(shell echo $(ver) | tr '.' '-')
linux_binary := dist/Missile-Commander
windows_binary := dist/Missile-Commander.exe
sources := $(shell find project/)

edit: ## Edit the project in Godot
	(cd project ; godot project.godot) &
.PHONY: edit

run: ## Run the project
	(cd project ; godot) &
.PHONY: run

version: ## Display the project version that will be produced by 'make build'
	@:
	$(info $(ver))
.PHONY: version

$(linux_binary): $(sources)
	( \
		cd project && \
		godot --quiet --headless \
			--export-release 'Linux/X11' ../$(linux_binary) \
	)
linux: $(linux_binary) ## Build Linux binary in dist/
.PHONY: linux

$(windows_binary): $(sources)
	( \
		cd project && \
		godot --quiet --headless \
			--export-release 'Windows Desktop' ../$(windows_binary) \
	)
windows: $(windows_binary) ## Build Windows binary in dist/
.PHONY: windows

build: windows linux  ## Build Windows and Linux binaries in dist/
.PHONY: build

clean:  ## Remove built and intermediate files
	rm -rf dist/*
.PHONY: clean

