FROM tailscale/tailscale:stable AS tailscale
FROM ubuntu-modernunix AS modernunix
FROM ubuntu-vscode AS vscode
FROM ubuntu-gobuilder AS gobuilder

FROM ubuntu-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install auto-apt-proxy at first
RUN apt update && apt install auto-apt-proxy -y && auto-apt-proxy

# Install all requested packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        systemd \
        gnupg \
        ca-certificates \
        sudo \
        vim \
        mosh \
        dnsutils \
        telnet \
        net-tools \
        curl \
        sed \
        git \
        tmux \
        language-pack-ko \
        language-pack-en \
        iproute2 \
        unzip \
        wget \
        jq \
        nnn \
        tree \
        btop \
        netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin
COPY --from=gobuilder /usr/local/lib/ /usr/local/lib/
COPY --from=gobuilder /usr/local/bin/ /usr/local/bin/
COPY --from=modernunix --chown=ubuntu:ubuntu /usr/local/bin/ /home/ubuntu/.local/bin/
COPY --from=vscode --chown=ubuntu:ubuntu /root/.local/bin/ /home/ubuntu/.local/bin/
RUN setcap 'cap_net_bind_service=+ep' /home/ubuntu/.local/bin/code

USER ubuntu
WORKDIR /home/ubuntu
RUN curl -fsSL https://fnm.vercel.app/install | bash && \
    curl -LsSf https://astral.sh/uv/install.sh | sh && \
    touch .bash_history && \
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> .bashrc && \
    echo 'eval "$(mcfly init bash)"' >> .bashrc 

