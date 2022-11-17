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
	@embassy-sdk verify s9pk $(ID_NAME).s9pk
	@echo " Done!"
	@echo "   Filesize: $(shell du -h $(ID_NAME).s9pk) is ready"

clean:
	rm -f image.tar
	rm -f $(ID_NAME).s9pk
	rm -f scripts/*.js
	rm -rf docker-images

$(ID_NAME).s9pk: manifest.yaml docs/instructions.md icon.png LICENSE scripts/embassy.js docker-images/aarch64.tar docker-images/x86_64.tar
	@if ! [ -z "$(ARCH)" ]; then cp docker-images/$(ARCH).tar image.tar; echo "* image.tar compiled for $(ARCH)"; fi
	embassy-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh agora/target/aarch64-unknown-linux-musl/release/agora
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(ID_NAME)/main:$(VERSION) --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .

agora/target/aarch64-unknown-linux-musl/release/agora: $(AGORA_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/agora:/home/rust/src messense/rust-musl-cross:aarch64-musl cargo build --release

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh agora/target/x86_64-unknown-linux-musl/release/agora
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(ID_NAME)/main:$(VERSION) --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .

agora/target/x86_64-unknown-linux-musl/release/agora: $(AGORA_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/agora:/home/rust/src messense/rust-musl-cross:x86_64-musl cargo build --release

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js
