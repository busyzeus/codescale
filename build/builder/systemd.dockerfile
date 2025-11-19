FROM ubuntu-systemd-base

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install all requested packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        systemd \
        openssh-server \
        language-pack-ko \
        language-pack-en \
        sudo \
        auto-apt-proxy \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-locale LANG=ko_KR.UTF-8 && \
    update-locale LC_MESSAGES=en_US.UTF-8 
    
RUN id -u ubuntu >/dev/null 2>&1 || (groupadd -g 1000 ubuntu && useradd -m -u 1000 -g 1000 -s /bin/bash ubuntu) && \
    passwd -l ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-ubuntu-nopasswd && \
    chmod 440 /etc/sudoers.d/90-ubuntu-nopasswd && \
    mkdir -m 700 -p /home/ubuntu/.ssh && \
    mkdir -p /home/ubuntu/.local/bin && \
    chown -R ubuntu:ubuntu /home/ubuntu

# https://github.com/trfore/docker-ubuntu2404-systemd/blob/main/Dockerfile
RUN find /lib/systemd/system/ -type f \( -name "*udev*" -o -name "*getty*" \) -printf "%f\0" | xargs -0 systemctl mask \
    && systemctl mask \
    systemd-remount-fs.service \
    systemd-logind.service 

STOPSIGNAL SIGRTMIN+3

CMD ["/lib/systemd/systemd"]
