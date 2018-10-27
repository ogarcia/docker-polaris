#! /bin/sh
#
# build.sh
# Copyright (C) 2018 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the GNU GPLv3 license.
#

# enable edge repository
sed -i -e 's/v[[:digit:]]\.[[:digit:]]/edge/g' /etc/apk/repositories

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add cargo libgcc make openssl openssl-dev rust

# extract software
cd /tmp/build
tar xzf polaris.tar.gz

# build polaris
cargo build --release

# install polaris
install -D -m755 /tmp/scripts/run-polaris \
  /usr/bin/run-polaris
install -D -m755 /tmp/build/target/release/polaris \
  /usr/bin/polaris
install -d /usr/share/polaris
cp -r web /usr/share/polaris

# create polaris user
adduser -S -D -H -h /var/lib/polaris -s /sbin/nologin -G users \
  -g polaris polaris
mkdir -p /var/lib/polaris
chown polaris:users /var/lib/polaris

# remove build deps
apk --no-progress del cargo make openssl-dev rust
rm -rf /root/.ash_history /root/.cargo /tmp/* /var/cache/apk/*
