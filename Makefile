# This wil not install anything onto your laptop.
# it all goes into .dep and .bin. so it will not pollute your system,

# TODO: Change to Task file so it wokrs easily on all Desktops. 

BIN_NAME=.bin
BIN_ROOT=$(PWD)/$(BIN_NAME)
DEP_NAME=.dep
DEP_ROOT=$(PWD)/$(DEP_NAME)

WAILS_BIN_NAME=wails
WAILS_BIN_WHICH=$(shell command -v $(WAILS_BIN_NAME))

TEMPL_BIN_NAME=templ
TEMPL_BIN_WHICH=$(shell command -v $(TEMPL_BIN_NAME))

BUN_BIN_NAME=bun
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

### gen

gen:
	$(TEMPL_BIN_NAME) generate
	cd components && $(TEMPL_BIN_NAME) generate

### bin 
bin-del:
	rm -rf $(BIN_ROOT)
bin: bin-del
	mkdir -p $(BIN_ROOT)
	@echo $(BIN_NAME) >> .gitignore

	bun install
	cd frontend && bun install

	go build -o $(BIN_ROOT)/$(NAME) .

### run 

run:
	# todo: run the binary. still cant build the binary :)

	cd frontend && bun run dev


### wails stuff

wails-h:
	$(WAILS_BIN_NAME) --help
	$(WAILS_BIN_NAME) doctor
wails-init:
	#$(WAILS_BIN_NAME) init
wails-gen:
	$(WAILS_BIN_NAME) generate

wails-dev-h:
	$(WAILS_BIN_NAME) dev --help
wails-dev:
	$(WAILS_BIN_NAME) dev

wails-build-h:
	$(WAILS_BIN_NAME) build --help
wails-build:
	# todo: sniff OS and pick commands...
	# darwin
	$(WAILS_BIN_NAME) build --clean
	$(WAILS_BIN_NAME) build --clean --platform darwin/arm64
	$(WAILS_BIN_NAME) build --clean --platform darwin
	$(WAILS_BIN_NAME) build --clean --platform darwin/universal
	# windows
	$(WAILS_BIN_NAME) build --clean --platform windows/amd64
	$(WAILS_BIN_NAME) build --clean --platform windows/arm64


	