#
#MIT License
#
# Copyright © Ashok Raja <ashokrajar@gmail.com>
#
# Authors: Ashok Raja <ashokrajar@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
APP_NAME=$(notdir $(shell pwd))
APP_VERSION=$(shell gitversion /showvariable SemVer)
APP_ARCH=$(shell go env GOARCH)
BUILD_DIR=build
GIT_BRANCH_NAME=$(shell git rev-parse --abbrev-ref HEAD)
DOCKER_HUB_NAMESPACE="ashokrajar"
NETRC_FILEPATH="./.netrc"

GOOS := $(shell go env GOOS)
GOARCH := $(APP_ARCH)

build_host := $(shell hostname)
build_user := $(shell whoami)
build_time_str := $(shell date)
bin_dir=${BUILD_DIR}/bin
reports_dir=${BUILD_DIR}/reports

ifeq ($(GOOS), windows)
	app_file_name=$(APP_NAME)_$(GOOS)_$(GOARCH).exe
else
	app_file_name=$(APP_NAME)_$(GOOS)_$(GOARCH)
endif

init:
	@mkdir -p $(bin_dir)
	@mkdir -p $(reports_dir)

clean:
	@rm -rf $(BUILD_DIR)

build: init
	@echo "Building $(APP_NAME):$(APP_VERSION) ..."
	GOARCH="$(GOARCH)" go build -ldflags "-X '$(APP_NAME)/cmd.Version=$(APP_VERSION)' -X '$(APP_NAME)/cmd.VCSBranch=$(GIT_BRANCH_NAME)' -X '$(APP_NAME)/cmd.BuildHost=$(build_host)' -X '$(APP_NAME)/cmd.BuiltBy=$(build_user)' -X '$(APP_NAME)/cmd.BuildTime=$(build_time_str)'" \
		-o $(bin_dir)/$(app_file_name)
	@echo "Binary $(app_file_name) saved in $(bin_dir)"

# Add this option if private repo is included
#		--secret id=private-repo,src=$(NETRC_FILEPATH)
build-docker-image: init
	@echo "Building $(APP_NAME):$(APP_VERSION) docker image ..."
	@docker build \
		--build-arg APP_VERSION=$(APP_VERSION) \
		--build-arg APP_ARCH=$(GOARCH) \
		--build-arg GIT_BRANCH_NAME=$(GIT_BRANCH_NAME) \
		-t $(DOCKER_HUB_NAMESPACE)/$(APP_NAME):$(APP_VERSION) .

push-docker-image:
	@echo "Pushing $(APP_NAME):$(APP_VERSION) docker image ..."
	@docker push $(DOCKER_HUB_NAMESPACE)/$(APP_NAME):$(APP_VERSION)

build-push-docker-image: build-docker-image push-docker-image
	@echo "Building app docker image $(APP_NAME):$(APP_VERSION) and pushing in to Docker Hub Namespace:$(DOCKER_HUB_NAMESPACE)  ..."

test:
	@go test -v ./...

run-go-junit-test-with-coverage: init
	@go test -v -coverprofile=$(reports_dir)/coverage.txt -covermode count ./... | go-junit-report -out $(reports_dir)/report.xml
	@gocov convert $(reports_dir)/coverage.txt | gocov-xml > $(reports_dir)/coverage.xml
