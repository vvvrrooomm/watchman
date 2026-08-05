#!/usr/bin/env bash
set -euo pipefail

VERSION="${VERSION:-latest}"
WATCHMAN_DIR="${WATCHMAN_DIR:-/usr/local}"

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root.' >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Install the minimal build/runtime dependencies needed to build Watchman from the
# official upstream release tarball. This avoids stale distribution packages.
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    python3 \
    libssl-dev \
    libevent-dev

if [ "${VERSION}" = "latest" ]; then
    VERSION="$(curl -fsSL https://api.github.com/repos/facebook/watchman/releases/latest | python3 -c 'import json,sys; data=json.load(sys.stdin); print(data.get("tag_name",""))')"
fi

if [ -z "${VERSION}" ]; then
    echo "Unable to determine the Watchman version to install." >&2
    exit 1
fi

if [[ "${VERSION}" != v* ]]; then
    VERSION="v${VERSION}"
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

TARBALL_URL="https://github.com/facebook/watchman/archive/refs/tags/${VERSION}.tar.gz"
ARCHIVE_PATH="${TMP_DIR}/watchman.tar.gz"

curl -fsSL "${TARBALL_URL}" -o "${ARCHIVE_PATH}"

mkdir -p "${TMP_DIR}/src"
tar -xzf "${ARCHIVE_PATH}" -C "${TMP_DIR}/src"
SOURCE_DIR="$(find "${TMP_DIR}/src" -mindepth 1 -maxdepth 1 -type d | head -n 1)"

cd "${SOURCE_DIR}"
./autogen.sh
./configure --prefix="${WATCHMAN_DIR}"
make -j"$(nproc)"
make install

mkdir -p "${WATCHMAN_DIR}/var/run/watchman"
chmod 2777 "${WATCHMAN_DIR}/var/run/watchman"

# Ensure the binary is on PATH for devcontainer users.
ln -sf "${WATCHMAN_DIR}/bin/watchman" /usr/local/bin/watchman

watchman --version

echo "Watchman ${VERSION} installed successfully."
