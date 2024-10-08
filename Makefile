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

print:
	@echo ""
	@echo "WAILS_BIN_NAME:    $(WAILS_BIN_NAME)"
	@echo "WAILS_BIN_WHICH:   $(WAILS_BIN_WHICH)"

	@echo ""
	@echo "TEMPL_BIN_NAME:    $(TEMPL_BIN_NAME)"
	@echo "TEMPL_BIN_WHICH:   $(TEMPL_BIN_WHICH)"

	@echo ""
	@echo "BUN_BIN_NAME:      $(BUN_BIN_NAME)"
	@echo "BUN_BIN_WHICH:     $(BUN_BIN_WHICH)"

mod-init:
	#go mod init main
mod-tidy:
	go mod tidy
mod-up: mod-tidy
	go install github.com/oligot/go-mod-upgrade@latest
	go-mod-upgrade
	$(MAKE) mod-tidy


dep: 
	rm -rf $(DEP_ROOT)
	mkdir -p $(DEP_ROOT)
	@echo $(DEP_NAME) >> .gitignore

	go install github.com/wailsapp/wails/v2/cmd/wails@latest
	mv $(GOPATH)/bin/wails $(DEP_ROOT)

	go install github.com/a-h/templ/cmd/templ@latest
	mv $(GOPATH)/bin/templ $(DEP_ROOT)

gen:
	$(TEMPL_BIN_NAME) generate
	cd components && $(TEMPL_BIN_NAME) generate


bin:
	rm -rf $(BIN_ROOT)
	mkdir -p $(BIN_ROOT)
	@echo $(BIN_NAME) >> .gitignore

	#bun install
	#cd frontend && bun install

	go build -o $(BIN_ROOT)/$(NAME) .

wails-h:
	$(WAILS_BIN_NAME) --help
	$(WAILS_BIN_NAME) doctor
wails-init:
	$(WAILS_BIN_NAME) init
wails-gen:
	$(WAILS_BIN_NAME) generate
wails-dev:
	$(WAILS_BIN_NAME) dev
wails-build:
	$(WAILS_BIN_NAME) build