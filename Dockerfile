FROM golang:1.20 AS build

ENV CGO_ENABLED=0
ENV GOOS=linux

WORKDIR /go/src/go-app-cli-template

COPY . /go/src/go-app-cli-template/

RUN go mod download && go mod verify

RUN go build .

# ---

FROM alpine:3.18.4

COPY --from=build /go/src/go-app-cli-template/go-app-cli-template /usr/bin/go-app-cli-template

ENTRYPOINT ["go-app-cli-template"]
