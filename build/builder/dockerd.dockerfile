FROM ubuntu-dockerd-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install all requested packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        gnupg \
        ca-certificates \
        curl \
        lsb-release \
        auto-apt-proxy \
    && install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    (id -u ubuntu >/dev/null 2>&1 && usermod -aG docker ubuntu)

