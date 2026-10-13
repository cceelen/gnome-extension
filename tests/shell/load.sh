#!/bin/sh
# Installs each zip, then has session.sh load it in a headless GNOME Shell
# and disable it. Fails if an extension is not active after the start or not
# inactive after the disable, or if the Shell logs an error with the uuid of
# one. For CI, in a container with gnome-shell (shell.yml); also by hand in a
# toolbox:
#
#   tests/shell/load.sh dist/*.shell-extension.zip
#
# The machine is not a UX8406 and has no sensor: the extensions load,
# enable and do nothing, which is what this test examines. Keys also has its
# compiled schema read.
set -eu

[ $# -gt 0 ] || { echo "usage: $0 ZIP..." >&2; exit 2; }

home=$(mktemp -d)
export HOME="$home" XDG_RUNTIME_DIR="$home/run" XDG_CONFIG_HOME="$home/.config"
mkdir -m 700 "$XDG_RUNTIME_DIR"
log="$home/shell.log"

uuids=
for zip in "$@"; do
    gnome-extensions install --force "$zip"
    uuid=$(basename "$zip" .shell-extension.zip)
    uuids="$uuids $uuid"
    schemas="$HOME/.local/share/gnome-shell/extensions/$uuid/schemas"
    if [ -d "$schemas" ]; then
        gsettings --schemadir "$schemas" list-recursively \
            "$(sed -n 's/^ *"settings-schema": *"\([^"]*\)".*/\1/p' \
                "$HOME/.local/share/gnome-shell/extensions/$uuid/metadata.json")" >/dev/null
    fi
done

# One session bus for gsettings and the Shell.
# shellcheck disable=SC2086 # one word for each uuid
exec dbus-run-session -- "$(dirname "$0")/session.sh" "$log" $uuids
