FROM ubuntu-systemd-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

RUN /bin/bash -c 'set -o pipefail && \
    curl --proto "=https" --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
    sh -s -- install linux --init none --no-confirm'

COPY nix/ /etc/systemd/system/
RUN ln -s /etc/systemd/system/nix-daemon.socket /etc/systemd/system/sockets.target.wants/nix-daemon.socket && \
    ln -s /etc/systemd/system/determinate-nixd.socket /etc/systemd/system/sockets.target.wants/determinate-nixd.socket && \
    ln -s /nix/var/nix/profiles/default/lib/tmpfiles.d/nix-daemon.conf /etc/tmpfiles.d/nix-daemon.conf


