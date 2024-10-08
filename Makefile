# This wil not install anything onto your laptop.
# it all goes into .dep and .bin. so it will not pollute your system,

# TODO: Change to Task file so it wokrs easily on all Desktops. 

BASE_SHELL_OS_NAME := $(shell uname -s | tr A-Z a-z)
BASE_SHELL_OS_ARCH := $(shell uname -m | tr A-Z a-z)

# os
BASE_OS_NAME := $(shell go env GOOS)
BASE_OS_ARCH := $(shell go env GOARCH)



BIN_NAME=.bin
BIN_ROOT=$(PWD)/$(BIN_NAME)
DEP_NAME=.dep
DEP_ROOT=$(PWD)/$(DEP_NAME)


BASE_DEP_BIN_GIT_NAME=git
ifeq ($(BASE_OS_NAME),windows)
BASE_DEP_BIN_GIT_NAME=git.exe
endif

WAILS_BIN_NAME=wails
ifeq ($(BASE_OS_NAME),windows)
WAILS_BIN_NAME=wails.exe
endif
WAILS_BIN_WHICH=$(shell command -v $(WAILS_BIN_NAME))

TEMPL_BIN_NAME=templ
ifeq ($(BASE_OS_NAME),windows)
TEMPL_BIN_NAME=templ.exe
endif
TEMPL_BIN_WHICH=$(shell command -v $(TEMPL_BIN_NAME))

BUN_BIN_NAME=bun
ifeq ($(BASE_OS_NAME),windows)
BUN_BIN_NAME=bun.exe
endif
BUN_BIN_WHICH=$(shell command -v $(BUN_BIN_NAME))

NAME=htmx-wails

export PATH:=$(BIN_ROOT):$(DEP_ROOT):$(PATH)

all: dep dep-print bin 

dep-print:
	@echo ""
	@echo "WAILS_BIN_NAME:    $(WAILS_BIN_NAME)"
	@echo "WAILS_BIN_WHICH:   $(WAILS_BIN_WHICH)"

	@echo ""
	@echo "TEMPL_BIN_NAME:    $(TEMPL_BIN_NAME)"
	@echo "TEMPL_BIN_WHICH:   $(TEMPL_BIN_WHICH)"

	@echo ""
	@echo "BUN_BIN_NAME:      $(BUN_BIN_NAME)"
	@echo "BUN_BIN_WHICH:     $(BUN_BIN_WHICH)"

### mod

mod-init:
	# had to do this initially....
	# also change the app.templ.go to use the component...
	#go mod init main
mod-tidy:
	go mod tidy
mod-up: mod-tidy
	go install github.com/oligot/go-mod-upgrade@latest
	go-mod-upgrade
	$(MAKE) mod-tidy

### dep

dep-del:
	rm -rf $(DEP_ROOT)
dep: dep-del
	
	mkdir -p $(DEP_ROOT)
	@echo $(DEP_NAME) >> .gitignore

	go install github.com/wailsapp/wails/v2/cmd/wails@latest
	mv $(GOPATH)/bin/wails $(DEP_ROOT)

	go install github.com/a-h/templ/cmd/templ@latest
	mv $(GOPATH)/bin/templ $(DEP_ROOT)

	brew install bun

### gen

gen:
	# seems to work...
	$(TEMPL_BIN_NAME) generate
	cd components && $(TEMPL_BIN_NAME) generate

### bin 
bin-del:
	rm -rf $(BIN_ROOT)
bin: bin-del
	mkdir -p $(BIN_ROOT)
	@echo $(BIN_NAME) >> .gitignore

	# fails...
	cd frontend && bun install
	cd frontend && bun run build

	go build -o $(BIN_ROOT)/$(NAME) .

### run 

run:
	# todo: run the binary. still cant build the binary :)

	cd frontend && bun run dev


### wails stuff

WAILS_PROJ_NAME=test-proj

wails-h:
	$(WAILS_BIN_NAME) --help
	$(WAILS_BIN_NAME) doctor

wails-init-del:
	rm -rf $(WAILS_PROJ_NAME)
wails-init: wails-init-del
	# https://wails.io/docs/gettingstarted/firstproject
	$(WAILS_BIN_NAME) init -n $(WAILS_PROJ_NAME) -t vanilla

wails-gen:
	$(WAILS_BIN_NAME) generate

wails-dev-h:
	$(WAILS_BIN_NAME) dev --help
wails-dev:
	$(WAILS_BIN_NAME) dev

wails-build-h:
	cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --help
wails-build:
	# todo: sniff OS and pick commands...
	# https://wails.io/docs/gettingstarted/building

ifeq ($(BASE_OS_NAME),darwin)
	$(MAKE) wails-build-darwin
endif
ifeq ($(BASE_OS_NAME),windows)
	$(MAKE) wails-build-windows
endif


wails-build-darwin:
# darwin
	cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean
	#cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean --platform darwin/arm64
	#cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean --platform darwin
	cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean --platform darwin/universal

wails-build-windows:
	# windows
	cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean --platform windows/amd64
	cd $(WAILS_PROJ_NAME) && $(WAILS_BIN_NAME) build --clean --platform windows/arm64


	

wails-run:
	# switch based on os

ifeq ($(BASE_OS_NAME),darwin)
	$(MAKE) wails-run-darwin
endif
ifeq ($(BASE_OS_NAME),windows)
	$(MAKE) wails-run-windows
endif

wails-run-darwin:
	cd $(WAILS_PROJ_NAME)/build/bin && open $(WAILS_PROJ_NAME).app
wails-run-windows:
	cd $(WAILS_PROJ_NAME)/build/bin && open $(WAILS_PROJ_NAME).exe

	


	