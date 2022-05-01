# Basic instructions for setup of Agora

This project wraps the [Agora](https://github.com/agora-org/agora) app for EmbassyOS.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [toml](https://crates.io/crates/toml-cli)
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s).

```
git clone git@github.com:yzernik/agora-wrapper.git
cd agora-wrapper
git submodule update --init --recursive
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
```

## Building

To build the project, run the following commands:

```
make
```

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.

```
scp agora.s9pk root@<LAN ID>:/root
```

Run the following command to determine successful install:

```
embassy-cli auth login
embassy-cli package install agora.s9pk
```
