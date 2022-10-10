ID_NAME := $(shell yq e ".id" manifest.yaml)
VERSION := $(shell yq e ".version" manifest.yaml)
TS_FILES := $(shell find ./ -name \*.ts)
AGORA_SRC := $(shell find ./agora/src) agora/Cargo.toml agora/Cargo.lock

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

install: all
	embassy-cli package install $(ID_NAME).s9pk

verify: $(ID_NAME).s9pk
	embassy-sdk verify s9pk $(ID_NAME).s9pk

clean:
	rm -f image.tar
	rm -f $(ID_NAME).s9pk
	rm -f scripts/*.js

$(ID_NAME).s9pk: manifest.yaml docs/instructions.md icon.png LICENSE scripts/embassy.js image.tar
	embassy-sdk pack

image.tar: Dockerfile docker_entrypoint.sh agora/target/x86_64-unknown-linux-musl/release/agora
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(ID_NAME)/main:$(VERSION) --platform=linux/amd64 -o type=docker,dest=image.tar -f ./Dockerfile .

agora/target/x86_64-unknown-linux-musl/release/agora: $(AGORA_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/agora:/home/rust/src messense/rust-musl-cross:x86_64-musl cargo build --release

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js
