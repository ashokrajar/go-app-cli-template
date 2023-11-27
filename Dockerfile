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
FROM golang:1.20.11 AS build

ARG APP_VERSION=unknown
ARG APP_ARCH=amd64
ARG GIT_BRANCH_NAME=unknown

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=${APP_ARCH}
# ENV GOPRIVATE=github.com/ashokrajar/*  # Placeholder to enable your private repos
ENV APP_NAME=go-app-cli-template


WORKDIR /go/src/${APP_NAME}

COPY go.* /go/src/${APP_NAME}/

# Use this if private repo is included
# RUN --mount=type=secret,id=private-repo,dst=/root/.netrc go mod download
RUN go mod download

COPY . /go/src/${APP_NAME}/

RUN go build -ldflags "-X '${APP_NAME}/cmd.Version=${APP_VERSION}' -X '${APP_NAME}/cmd.VCSBranch=${GIT_BRANCH_NAME}' -X '${APP_NAME}/cmd.BuildHost=$(hostname)' -X '${APP_NAME}/cmd.BuiltBy=$(whoami)' -X '${APP_NAME}/cmd.BuildTime=$(date)'" .

# ---

FROM alpine:3.18.4

ENV APP_NAME=go-app-cli-template

COPY --from=build /go/src/${APP_NAME}/${APP_NAME} /usr/bin/${APP_NAME}

ENTRYPOINT ["go-app-cli-template"]
