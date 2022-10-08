# Basic instructions for setup of Agora

This project wraps the [Agora](https://github.com/agora-org/agora) app for EmbassyOS.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Build enviroment
Prepare your EmbassyOS build enviroment. In this example we are using Ubuntu 20.04.

1. Install docker
```
curl -fsSL https://get.docker.com -o- | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER
```
2. Set buildx as the default builder
```
docker buildx install
docker buildx create --use
```
3. Enable cross-arch emulated builds in docker
```
docker run --privileged --rm linuxkit/binfmt:v0.8
```
4. Install yq
```
sudo snap install yq
```
5. Install deno
```
sudo snap install deno
```
6. Install essentials build packages
```
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```
7. Install Rust
```
curl https://sh.rustup.rs -sSf | sh
# Choose nr 1 (default install)
source $HOME/.cargo/env
```
8. Build and install embassy-sdk
```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
embassy-sdk init
```
9. Enable multi-architecture support for AMD/Intel processors.
```
[[ $(arch) == *86* ]] && docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```
Now you are ready to build your **agora** service

## Cloning

Clone the project locally. 

```
git clone https://github.com/yzernik/agora-wrapper.git
cd agora-wrapper
```

## Building

To build the **agora** service, run the following commands:

```
git submodule update --init --recursive
make
```

## Installing (on Embassy)

Run the following commands to determine successful install:
> :information_source: Change embassy-q1w2e3r4.local to your Embassy address

```
embassy-cli auth login
#Enter your embassy password
embassy-cli --host https://embassy-q1w2e3r4.local package install agora.s9pk
```
**Tip:** You can also install the agora.s9pk using **Sideload Service** under the **Embassy > SETTINGS** section.
## Verify Install

Go to your Embassy Services page, select **agora**, configure and start the service.

**Done!** 
