#!/usr/bin/env bash
# Xenoglyph — Unfurl (KWin Effect): install.  ./install.sh
set -euo pipefail
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DST=${XDG_DATA_HOME:-$HOME/.local/share}/kwin/effects/xenoglyph_unfurl
rm -rf "$DST"; mkdir -p "$DST"
for f in "$HERE"/* "$HERE"/.[!.]*; do
    [[ -e $f ]] || continue
    case ${f##*/} in README.md|LICENSE|install.sh|screenshots|.git) continue ;; esac
    cp -r "$f" "$DST"/
done
for e in fade glide scale kinetic_scale; do kwriteconfig6 --file kwinrc --group Plugins --key ${e}Enabled false; done
kwriteconfig6 --file kwinrc --group Plugins --key xenoglyph_unfurlEnabled true
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.loadEffect xenoglyph_unfurl >/dev/null 2>&1 || true
