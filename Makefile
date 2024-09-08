SHELL=/bin/bash

help: ## Show this help.
	@# Optionally add 'sort' before 'awk'
	@grep -E '^[^_][a-zA-Z_\/\.%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
.PHONY: help

# Our source code
sources := $(shell find project -path project/.godot -prune -o -print)
version := $(shell grep config/version project/project.godot | cut -d'"' -f2)
# Output directories for built project
dist_linux := dist/missile-commander-linux
dist_windows := dist/missile-commander-windows
exe_linux := $(dist_linux)/missile-commander
exe_windows := $(dist_windows)/Missile\ Commander.exe
# Path to install tools
exe_dir := ~/.local/bin

edit: ## Edit the project in Godot
	(cd project ; godot project.godot) &
.PHONY: edit

run: ## Run the project
	(cd project ; godot) &
.PHONY: run

version: ## Show the current project version number, from project.godot
	@echo $(version)

clean:  ## Remove built and intermediate files
	rm -rf dist/*
.PHONY: clean

assert_no_diffs:
	@git diff --quiet || (echo "Error: Uncommitted diffs" ; git status -s ; false)
.PHONY: assert_no_diffs

bump:  ## Bump the minor version number in-place in project.godot
	$(eval major := $(shell echo $(version) | cut -d. -f1))
	$(eval minor := $(shell echo $(version) | cut -d. -f2))
	$(eval bumped := $(shell echo $(major).$$(($(minor)+1))))
	sed -i s!config/version=\"$(version)\"!config/version=\"$(bumped)\"! project/project.godot
	$(eval version := $(bumped))
.PHONY: bump

$(exe_linux): $(sources)
	mkdir -p $(dist_linux)
	cd project ;\
	godot --quiet --headless --export-release 'Linux' ../$(exe_linux)

$(exe_windows): $(sources)
	mkdir -p $(dist_windows)
	cd project ;\
	godot --quiet --headless --export-release 'Windows' ../$(exe_windows)

linux: $(exe_linux) ## Build Linux binary in dist/
.PHONY: linux

windows: $(exe_windows) ## Build Windows binary in dist/
.PHONY: windows

build: linux windows ## Build Windows and Linux binaries in dist/
.PHONY: build

# Install a command-line tool used to upload to itch.io
$(exe_dir)/butler:
	cd $(exe_dir) ;\
	wget -q https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default -O butler.zip ;\
	unzip -q butler.zip butler ;\
	chmod a+x butler ;\
	butler -V

commit: ## Commit changes
	git add .
	git commit -q -m "v$(version)"

tag: ## tag current commit with version, and push
	git tag -a -m "" "v$(version)"
	git push -q --follow-tags
.PHONY: tag

upload: build $(exe_dir)/butler  ## Upload builds to itch.io
	bin/upload $(version) linux $(dist_linux)
	bin/upload $(version) windows $(dist_windows)
.PHONY: upload

release: assert_no_diffs bump build commit tag upload ## Top level command to bump, build, commit, tag, and upload
.PHONY: release

