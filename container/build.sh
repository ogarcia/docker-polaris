#! /bin/sh
#
# build.sh
# Copyright (C) 2018-2025 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add build-base curl openssl openssl-dev sqlite-dev sqlite-static
curl https://sh.rustup.rs -sSf | sh -s -- -q -y --default-toolchain stable

# extract software
cd /polaris/src
tar xzf polaris.tar.gz

# build polaris
cd /polaris/src/polaris
source $HOME/.cargo/env
POLARIS_WEB_DIR="/usr/share/polaris/web" \
  POLARIS_CONFIG_DIR="/var/lib/polaris" \
  POLARIS_DATA_DIR="/var/lib/polaris" \
  POLARIS_DB_DIR="/var/lib/polaris" \
  POLARIS_LOG_DIR="/var/log/polaris" \
  POLARIS_CACHE_DIR="/var/cache/polaris" \
  POLARIS_PID_DIR="/tmp/polaris" \
  cargo build --release

# test binary
/polaris/src/polaris/target/release/polaris --help

# install polaris
install -D -m0755 "/polaris/build/run-polaris" \
  "/polaris/pkg/bin/run-polaris"
install -D -m0755 "/polaris/src/polaris/target/release/polaris" \
  "/polaris/pkg/bin/polaris"
install -d -m0755 "/polaris/pkg/usr/share/polaris"
cp -r "web" "/polaris/pkg/usr/share/polaris"
find "/polaris/pkg/usr/share/polaris" -type f -exec chmod -x {} \;
