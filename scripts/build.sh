#! /bin/sh
#
# build.sh
# Copyright (C) 2018-2020 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add build-base curl openssl openssl-dev sqlite-dev
curl https://sh.rustup.rs -sSf | sh -s -- -q -y --default-toolchain nightly

# extract software
cd /polaris/src
tar xzf polaris.tar.gz

# build polaris
cd /polaris/src/polaris
source $HOME/.cargo/env
RUSTFLAGS="-C target-feature=-crt-static" cargo build --release

# install polaris
install -D -m0755 "/polaris/scripts/run-polaris" \
  "/polaris/pkg/bin/run-polaris"
install -D -m0755 "/polaris/src/polaris/target/release/polaris" \
  "/polaris/pkg/bin/polaris"
install -d -m0755 "/polaris/pkg/usr/share/polaris"
cp -r "web" "/polaris/pkg/usr/share/polaris"
cp -r "swagger" "/polaris/pkg/usr/share/polaris"
find "/polaris/pkg/usr/share/polaris" -type f -exec chmod -x {} \;
install -d -m0755 -o100 -g100 "/polaris/pkg/var/lib/polaris"

# create polaris user
adduser -S -D -H -h /var/lib/polaris -s /sbin/nologin -G users \
  -g polaris polaris
install -d -m0755 "/polaris/pkg/etc"
install -m644 "/etc/passwd" "/polaris/pkg/etc/passwd"
install -m644 "/etc/group" "/polaris/pkg/etc/group"
install -m640 -gshadow "/etc/shadow" "/polaris/pkg/etc/shadow"
