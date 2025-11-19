FROM ubuntu-gobuilder-base

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

ARG TARGETOS=linux
ARG TARGETARCH=amd64

WORKDIR /root
RUN set -eux; \
    echo "Fetching latest stable Go version..."; \
    GO_VERSION=$(curl -s "https://go.dev/dl/?mode=json" | jq -r '(.[] | select(.stable == true) | .version)' | head -n 1); \
    if [ -z "$GO_VERSION" ]; then echo "Failed to find latest Go version"; exit 1; fi; \
    echo "Latest version found: $GO_VERSION"; \
    DOWNLOAD_URL="https://go.dev/dl/${GO_VERSION}.${TARGETOS}-${TARGETARCH}.tar.gz"; \
    echo "Downloading from $DOWNLOAD_URL"; \
    curl -fsSL "$DOWNLOAD_URL" -o go.tar.gz && \
    tar -xzf go.tar.gz && \
    rm go.tar.gz && \
    mv go /usr/local/lib/${GO_VERSION} && \
    ln -s ./${GO_VERSION} /usr/local/lib/go && \
    ln -s ../lib/go/bin/go /usr/local/bin/go && \
    ln -s ../lib/go/bin/gofmt /usr/local/bin/gofmt 

# go/bin/protoc-gen-go, protoc-gen-go-grpc, cheat 
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install github.com/cheat/cheat/cmd/cheat@latest && \
    mv /root/go/bin/* /usr/local/bin/ && \
    go clean -cache && go clean -modcache

RUN set -eux; \
    PROTOC_ARCH=$TARGETARCH; \
    if [ "$PROTOC_ARCH" = "amd64" ]; then \
        PROTOC_ARCH="x86_64"; \
    elif [ "$PROTOC_ARCH" = "arm64" ]; then \
        PROTOC_ARCH="aarch_64"; \
    else \
        echo "Unsupported architecture: $PROTOC_ARCH"; \
        exit 1; \
    fi; \
    echo "Targeting Protoc Architecture: $PROTOC_ARCH"; \
    echo "Fetching latest protoc release info..."; \
    API_RESPONSE=$(curl -s "https://api.github.com/repos/protocolbuffers/protobuf/releases/latest"); \
    DOWNLOAD_URL=$(printf "%s" "$API_RESPONSE" | jq -r ".assets[] | select(.name | contains(\"${TARGETOS}-${PROTOC_ARCH}.zip\")) | .browser_download_url"); \
    PROTOC_VERSION=$(printf "%s" "$API_RESPONSE" | jq -r ".tag_name"); \
    FILENAME_ONLY=$(basename "$DOWNLOAD_URL" .zip); \
    if [ -z "$DOWNLOAD_URL" ]; then echo "Failed to find download URL for $PROTOC_ARCH"; exit 1; fi; \
    if [ -z "$PROTOC_VERSION" ]; then echo "Failed to find version tag"; exit 1; fi; \
    echo "Found protoc version: $PROTOC_VERSION"; \
    echo "Downloading: $DOWNLOAD_URL"; \
    curl -fsSL "$DOWNLOAD_URL" -o protoc.zip &&\
    unzip -o protoc.zip -d /usr/local/lib/$FILENAME_ONLY &&\
    rm protoc.zip && \
    ln -s ./$FILENAME_ONLY /usr/local/lib/protoc && \
    ln -s ../lib/protoc/bin/protoc /usr/local/bin/protoc && \
    echo "protoc version:"; \
    /usr/local/bin/protoc --version

# ENTRYPOINT는 ubuntu:24.04에서 bash로 설정되어 있다.
