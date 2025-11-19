FROM ubuntu-modernunix-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        ca-certificates \
        gzip \
        tar \
        openssl \
        jq \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/get-gah/gah/refs/heads/master/tools/install.sh)" && \
    set -e; \
    for pkg in \
            bootandy/dust \
            mr-karan/doggo \
            dandavison/delta \
            sharkdp/bat \
            eza-community/eza \
            lsd-rs/lsd \
            muesli/duf \
            sharkdp/fd \
            BurntSushi/ripgrep \
            junegunn/fzf \
            jqlang/jq \
            ajeetdsouza/zoxide \
            protocolbuffers/protobuf-javascript \
            grpc/grpc-web \
            jesseduffield/lazygit \
            theryangeary/choose \
            chmln/sd \
            ClementTsang/bottom \
            dalance/procs \
            orf/gping \
            sharkdp/hyperfine \
            ducaale/xh \
            cantino/mcfly \
        ; do \
        echo gah install $pkg --unattended; \
        gah install $pkg --unattended; \
    done && \
    chown root:root /usr/local/bin/*

# ENTRYPOINT는 ubuntu:24.04에서 bash로 설정되어 있다.
