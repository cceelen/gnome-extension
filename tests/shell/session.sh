#!/bin/sh
# The part of load.sh in the session bus: starts the Shell with the
# extensions enabled, checks their state after the start and after a
# disable, and reads the log of the Shell.
#
# Usage: session.sh LOG UUID...
set -eu

log=$1
shift
list=$(printf '"%s"\n' "$@" | paste -sd, -)
gsettings set org.gnome.shell disable-user-extensions false
gsettings set org.gnome.shell enabled-extensions "[$list]"
gnome-shell --headless --wayland --no-x11 --virtual-monitor 1280x800 >"$log" 2>&1 &
pid=$!
trap 'kill "$pid" 2>/dev/null || true' EXIT

# The interface of the Shell itself: the command gnome-extensions is not the
# same in all versions.
call() {
    gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell \
        --method "$@"
}

# org.gnome.Shell answers when the Shell has started, with the extensions.
for _ in $(seq 60); do
    call org.freedesktop.DBus.Peer.Ping >/dev/null 2>&1 && break
    kill -0 "$pid" || { cat "$log"; exit 1; }
    sleep 1
done
sleep 3

# The state is a double, ExtensionState of misc/extensionUtils.js.
state() {
    info=$(call org.gnome.Shell.Extensions.GetExtensionInfo "$1")
    case $(echo "$info" | grep -o "'state': <[0-9.]*>") in
    *"<1.0>") echo ACTIVE ;;
    *"<2.0>") echo INACTIVE ;;
    *"<3.0>") echo ERROR ;;
    *) echo "UNKNOWN: $info" ;;
    esac
}

failed=0
for uuid in "$@"; do
    now=$(state "$uuid")
    echo "$uuid: $now after the start"
    [ "$now" = ACTIVE ] || failed=1
done
# disable() must undo enable() without an error.
for uuid in "$@"; do
    call org.gnome.Shell.Extensions.DisableExtension "$uuid" >/dev/null
    sleep 1
    now=$(state "$uuid")
    echo "$uuid: $now after the disable"
    [ "$now" = INACTIVE ] || failed=1
done
for uuid in "$@"; do
    if grep -F "$uuid" "$log" | grep -Ei "error|exception|critical"; then failed=1; fi
done
[ "$failed" = 0 ] || { echo "--- log of the Shell"; cat "$log"; exit 1; }
