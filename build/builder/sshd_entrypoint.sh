#!/bin/bash
set -e

# Check if the privilege separation directory exists, if not create it
# This handles cases where /run is mounted as tmpfs
if [ ! -d "/run/sshd" ]; then
  mkdir -p /run/sshd
  # Set correct permissions implies root only access typically
  chmod 0755 /run/sshd
fi

# (Optional) Generate host keys if missing
# This is crucial if /etc/ssh is also ephemeral or a volume
ssh-keygen -A

# Execute the command passed to docker run (e.g., /usr/sbin/sshd -D -e)
# 'exec' replaces the shell process with the target process
# ensuring sshd becomes PID 1 to receive signals correctly
exec "$@"
