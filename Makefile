help: ## Show this help.
	@# Optionally add 'sort' before 'awk'
	@grep -E '^[^_][a-zA-Z_\/\.%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
.PHONY: help

proj_dir := "project"
ver := $(shell grep "config/version" <"$(proj_dir)/project.godot" | cut -d'"' -f2)
# Version with dots replaced, for use in build output filenames
release := $(shell echo $(ver) | tr '.' '-')
name_linux := missile-commander
name_windows := Missile\ Commander.exe
binary_linux := dist/$(name_linux)
binary_windows := dist/$(name_windows)
sources := $(shell find project -path project/.godot -prune -o -print)
exe_dir := ~/.local/bin

edit: ## Edit the project in Godot
	(cd project ; godot project.godot) &
.PHONY: edit

run: ## Run the project
	(cd project ; godot) &
.PHONY: run

clean:  ## Remove built and intermediate files
	rm -rf dist/*
.PHONY: clean

version: ## Display the project version that will be produced by 'make build'
	@:
	$(info $(ver))
.PHONY: version

$(binary_linux): $(sources)
	cd project ;\
	godot --quiet --headless --export-release 'Linux/X11' ../$(binary_linux)

$(binary_windows): $(sources)
	cd project ;\
	godot --quiet --headless --export-release 'Windows Desktop' ../$(binary_windows)

linux: $(binary_linux) ## Build Linux binary in dist/
.PHONY: linux

windows: $(binary_windows) ## Build Windows binary in dist/
.PHONY: windows

build: windows linux  ## Build Windows and Linux binaries in dist/
.PHONY: build

# Install a command-line tool used to upload to itch.io
$(exe_dir)/butler:
	cd $(exe_dir) ;\
	wget -q https://broth.itch.ovh/butler/linux-amd64/LATEST/archive/default -O butler.zip ;\
	unzip -q butler.zip butler ;\
	chmod a+x butler ;\
	butler -V

upload: build $(exe_dir)/butler  ## Upload builds to itch.io
	butler push --if-changed --userversion $(ver) $(binary_linux) tartley/missile-commander:linux
	butler push --if-changed --userversion $(ver) $(binary_windows) tartley/missile-commander:windows
.PHONY: upload

