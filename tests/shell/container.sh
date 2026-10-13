#!/bin/sh
# Runs load.sh in a Debian or Ubuntu container, as root: installs a GNOME
# Shell, starts a system bus, and runs the test as a user. shell.yml runs it
# in each image of its matrix; by hand:
#
#   docker run --rm -v "$PWD:/src:ro" ubuntu:26.04 /src/tests/shell/container.sh /src/dist/*.zip
#
# The Shell takes logind when /run/systemd/seats exists; a container has no
# logind, so the directory goes and the Shell uses no login manager.
set -eu

export DEBIAN_FRONTEND=noninteractive
apt-get -qq update
apt-get -qq install -y --no-install-recommends \
    gnome-shell dbus-daemon dbus-user-session libglib2.0-bin libgl1-mesa-dri unzip >/dev/null
gnome-shell --version
rm -rf /run/systemd/seats
mkdir -p /run/dbus
dbus-daemon --system --fork
id tester >/dev/null 2>&1 || useradd --create-home tester
for zip in "$@"; do cp "$zip" /tmp/; done
cd /tmp
# shellcheck disable=SC2046
runuser -u tester -- "$(dirname "$0")/load.sh" $(for zip in "$@"; do echo "/tmp/${zip##*/}"; done)
