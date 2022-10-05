FROM --platform=linux/arm64/v8 rust:1.59.0-buster AS builder

WORKDIR /app

# Copy the source code.
COPY agora ./

RUN cargo build --release

FROM --platform=linux/arm64/v8 debian:buster-slim

COPY --from=builder /app/target/release/agora /usr/local/bin/agora

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get install -y \
	iproute2 wget curl tini

RUN wget https://github.com/mikefarah/yq/releases/download/v4.12.2/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod +x /usr/local/bin/docker_entrypoint.sh

