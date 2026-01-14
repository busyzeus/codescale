FROM tailscale/tailscale:stable AS tailscale

FROM ubuntu-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install auto-apt-proxy at first
RUN apt update && apt install auto-apt-proxy -y && auto-apt-proxy

# Install all requested packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        gnupg \
        ca-certificates \
        sudo \
        vim \
        mosh \
        dnsutils \
        telnet \
        net-tools \
        apt-utils \
        whiptail \
        curl \
        sed \
        git \
        tmux \
        language-pack-ko \
        language-pack-en \
        iproute2 \
        unzip \
        wget \
        netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin




