#!/usr/bin/env bash
set -euo pipefail

# Resources
SCRIPTS_DIR="$HOME/.scripts"
REFERENCE_DOC="$SCRIPTS_DIR/reference.odt"
LUA_FILTER="$SCRIPTS_DIR/rule-to-scene-break.lua"

# Arg check
if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") FILE.md"
    exit 1
fi

INPUT="$1"

if [[ ! -f "$INPUT" ]]; then
    echo "Error: File not found: $INPUT"
    exit 1
fi

# Paths
INPUT_ABS="$(realpath "$INPUT")"
BASENAME="$(basename "$INPUT_ABS" .md)"
WORKDIR="$(dirname "$INPUT_ABS")"

ODT="$WORKDIR/$BASENAME.odt"
PDF="$WORKDIR/$BASENAME.pdf"

# Converting and print to terminal
echo "→ Converting Markdown to ODT..."
pandoc "$INPUT_ABS" \
    -o "$ODT" \
    --reference-doc="$REFERENCE_DOC" \
    --lua-filter="$LUA_FILTER"

echo "→ Converting ODT to PDF..."
libreoffice \
    --headless \
    --convert-to pdf \
    --outdir "$WORKDIR" \
    "$ODT"

echo "✓ Done: $PDF"
