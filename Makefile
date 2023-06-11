APP_NAME=$(notdir $(shell pwd))
APP_VERSION=0.1.0
BIN_DIR=bin
GIT_BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)

git_commit_id := $(shell git rev-parse --short HEAD)
build_time := $(shell date)
built_by := $(shell whoami)
build_host := $(shell hostname)
go_version := $(shell go version)
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
	@go build -ldflags "-X '$(APP_NAME)/cmd.Version=$(APP_VERSION)' -X '$(APP_NAME)/cmd.VCSBranch=$(GIT_BRANCH_NAME)' \
		-X '$(APP_NAME)/cmd.BuildTime=$(build_time)' -X '$(APP_NAME)/cmd.VCSCommitID=$(git_commit_id)' \
		-X '$(APP_NAME)/cmd.BuiltBy=$(built_by)' -X '$(APP_NAME)/cmd.BuildHost=$(build_host)' \
		-X '$(APP_NAME)/cmd.GOVersion=$(go_version)'" -o $(BIN_DIR)/$(app_file_name)
	@echo "Binary $(app_file_name) saved in $(BIN_DIR)"

build-docker-image: init
	@echo "Building $(APP_NAME) docker image ..."
	@docker build -t $(APP_NAME):$(APP_VERSION) .

test:
	@go test -v ./...
