EMVER := $(shell yq e ".version" manifest.yaml)
AGORA_SRC := $(shell find ./agora)
S9PK_PATH=$(shell find . -name agora.s9pk -print)

.DELETE_ON_ERROR:

all: verify

verify: agora.s9pk $(S9PK_PATH)
	embassy-sdk verify s9pk $(S9PK_PATH)

install: agora.s9pk
	embassy-cli package install agora.s9pk

agora.s9pk: manifest.yaml assets/* image.tar docs/instructions.md LICENSE icon.png
	embassy-sdk pack

image.tar: Dockerfile docker_entrypoint.sh assets/utils/*
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/agora/main:${EMVER}	--platform=linux/arm64/v8 -f Dockerfile -o type=docker,dest=image.tar .

clean:
	rm -f agora.s9pk
	rm -f image.tar
