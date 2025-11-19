FROM ubuntu-vscode-base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        tar \
        openssl \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN mkdir -p .local/bin && \
    curl -Lk 'https://update.code.visualstudio.com/latest/cli-linux-x64/stable' | tar -zxf - -C .local/bin && \
    echo '#!/bin/sh\ncode serve-web --host 0.0.0.0 --port ${CODE_PORT:-80} --without-connection-token --disable-telemetry' > .local/bin/codeweb.sh && \
    chmod +x .local/bin/codeweb.sh

# ENTRYPOINT는 ubuntu:24.04에서 bash로 설정되어 있다.
