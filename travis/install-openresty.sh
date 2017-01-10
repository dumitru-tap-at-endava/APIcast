#!/bin/sh
set -eux

PREFIX=${1:-$HOME/openresty}
OPENRESTY_ARCHIVE="openresty-${OPENRESTY_VERSION}"

if [ ! -d "${PREFIX}/bin" ]; then
  cd /tmp/
  wget -T 60 -q -c "http://openresty.org/download/${OPENRESTY_ARCHIVE}.tar.gz"
  tar -xzf "${OPENRESTY_ARCHIVE}.tar.gz"
  rm -rf "${OPENRESTY_ARCHIVE}.tar.gz"
  cd "${OPENRESTY_ARCHIVE}"
  ./configure --prefix="${PREFIX}" --with-ipv6 --with-luajit-xcflags=-DLUAJIT_ENABLE_LUA52COMPAT --with-debug
  make "-j$(grep -c processor /proc/cpuinfo)"
  make install
  ln -sf "${PREFIX}"/luajit/bin/luajit-* "${PREFIX}/luajit/bin/luajit"
  ln -sf "${PREFIX}"/luajit/include/luajit-* "${PREFIX}/luajit/include/lua5.1"
else
  echo "Using cached openresty."
fi