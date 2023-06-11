APP_NAME=$(notdir $(shell pwd))
APP_VERSION=$(shell gitversion /showvariable SemVer)
BIN_DIR=bin
GIT_BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)

go_os := $(shell go env GOOS)
go_arch := $(shell go env GOARCH)

ifeq ($(go_os), windows)
	app_file_name=$(APP_NAME)_$(go_os)_$(go_arch).exe
else
	app_file_name=$(APP_NAME)_$(go_os)_$(go_arch)
endif

init:
	@mkdir -p $(BIN_DIR)

build: init
	@echo "Building $(APP_NAME) ..."
	@go build -ldflags "-X '$(APP_NAME)/cmd.Version=$(APP_VERSION)' -X '$(APP_NAME)/cmd.VCSBranch=$(GIT_BRANCH_NAME)'" \
		-o $(BIN_DIR)/$(app_file_name)
	@echo "Binary $(app_file_name) saved in $(BIN_DIR)"

build-docker-image: init
	@echo "Building $(APP_NAME) docker image ..."
	@docker build -t $(APP_NAME):$(APP_VERSION) .

test:
	@go test -v ./...
