#!/bin/bash
set -e

# 1. Grab where the terminal is standing and find the main project folder
TOOLS_DIR=$(pwd)
PROJECT_ROOT=$(cd "$TOOLS_DIR/.." && pwd)

echo "📂 Tools folder: $TOOLS_DIR"
echo "📂 Project Root is: $PROJECT_ROOT"
echo "🔄 Generating smart patches for netherreactormod..."

# 2. Clean up old patches and prepare destination
mkdir -p "$PROJECT_ROOT/patches"
rm -f "$PROJECT_ROOT/patches"/*.patch

# 3. Create a temporary exclude file so diff knows what to ignore
# This ensures it completely ignores your root textures and gui/mob folders
echo "gui" > "$PROJECT_ROOT/tools/exclude.txt"
echo "mob" >> "$PROJECT_ROOT/tools/exclude.txt"
echo "particles.png" >> "$PROJECT_ROOT/tools/exclude.txt"
echo "terrain.png" >> "$PROJECT_ROOT/tools/exclude.txt"
echo ".DS_Store" >> "$PROJECT_ROOT/tools/exclude.txt"

# 4. RUN TOTAL UNIX DIFF:
# -N: treat absent files as empty (captures your brand new files)
# -a: treat all files as text
# -u: output unified diff lines
# -r: recursively compare subdirectories
# -w: ignore all whitespace and line ending mismatches
# -I: ignore the 1969 timestamp headers entirely!
# -X: use our exclusion list file
diff -Naurw -I '^[+-][+-][+-]' -X "$PROJECT_ROOT/tools/exclude.txt" "$PROJECT_ROOT/clean_src/net.minecraft" "$PROJECT_ROOT/src/net.minecraft" > "$PROJECT_ROOT/patches/mod_changes.patch" || true

# 5. Clean up the temporary exclusion file
rm -f "$PROJECT_ROOT/tools/exclude.txt"

echo "✅ Smart patch successfully generated inside the /patches/ folder!"
