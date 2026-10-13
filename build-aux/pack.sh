#!/bin/sh
# Makes the zip of one extension for extensions.gnome.org and for the release
# page: <uuid>.shell-extension.zip, the name that `gnome-extensions pack`
# gives. In it: the files of <extension>/extension/ with the links to
# gnome-common/ followed, the compiled schema, and LICENSE. Tests, READMEs and
# tools stay out, as the review guidelines ask.
#
# The zip is the same for the same tree: the files are in one order, with the
# time of the last commit (SOURCE_DATE_EPOCH, if set) and no extra fields.
#
# Usage: build-aux/pack.sh gnome-keys|gnome-rotation [OUTDIR]
set -eu

dir=${1:?usage: $0 EXTENSION_DIR [OUTDIR]}
out=${2:-dist}
root=$(cd "$(dirname "$0")/.." && pwd)
src="$root/$dir/extension"

[ -f "$src/metadata.json" ] || { echo "$0: no $dir/extension/metadata.json" >&2; exit 1; }
uuid=$(sed -n 's/^ *"uuid": *"\([^"]*\)".*/\1/p' "$src/metadata.json")
[ -n "$uuid" ] || { echo "$0: no uuid in $dir/extension/metadata.json" >&2; exit 1; }
epoch=${SOURCE_DATE_EPOCH:-$(git -C "$root" log -1 --format=%ct 2>/dev/null || echo 0)}

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
# -L: a link to gnome-common/ becomes the file it points to.
cp -RL "$src/." "$stage/"
cp "$root/LICENSE" "$stage/LICENSE"
# getSettings() reads schemas/gschemas.compiled; `gnome-extensions install`
# does not compile it. `gnome-extensions pack` puts it in the zip too.
if [ -d "$stage/schemas" ]; then
    glib-compile-schemas --strict "$stage/schemas"
fi
find "$stage" -exec touch -h -d "@$epoch" {} +

mkdir -p "$out"
zip=$(cd "$out" && pwd)/$uuid.shell-extension.zip
rm -f "$zip"
(cd "$stage" && find . -type f | sed 's|^\./||' | LC_ALL=C sort | TZ=UTC zip -q -X -D "$zip" -@)
echo "$zip"
