# go-app-cli-template
A sample Golang CLI application template.

## Contributing

As always feedbacks are greatly appreciated! Pull request even more ;)

### Prerequisite

- GoLang 1.20.x
- GOPATH is set
- GitVersion installed [GitVersion CLI](https://gitversion.net/docs/usage/command-line) for automatic semVersioning. 
- Docker (only if you want to create a new release candidate for deployment in dev/prod)

### Building

#### Build local binary

```bash
make build
```

#### Cross Compile for other platforms

```bash
# For Linux
export GOOS=linux
make build

# For MacOS
export GOOS=darwin
make build

# For Windows
export GOOS=windows
make build
```

#### Build Docker Image

```bash
make build-docker-image
```
