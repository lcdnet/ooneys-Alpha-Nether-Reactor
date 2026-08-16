#!/bin/bash
set -e

# 1. Grab where the terminal is standing and find the main project folder
TOOLS_DIR=$(pwd)
PROJECT_ROOT=$(cd "$TOOLS_DIR/.." && pwd)

echo "📂 Tools folder: $TOOLS_DIR"
echo "📂 Project Root is: $PROJECT_ROOT"
echo "🔄 Aligning workspace timestamps and generating patches..."

# 2. Clean up old patches and prepare destination
mkdir -p "$PROJECT_ROOT/patches"
rm -f "$PROJECT_ROOT/patches"/*.patch

# 3. FIXED PATH SEPARATOR:
# This targets the true nested folder layout (net/minecraft) to forcefully
# update the modified timestamps and overwrite that 1969 epoch decompiler glitch!
find "$PROJECT_ROOT/src/net/minecraft" -type f -exec touch {} +

# 4. Create a temporary exclude file so diff knows what to ignore
echo "gui" > "$PROJECT_ROOT/tools/exclude.txt"
echo "mob" >> "$PROJECT_ROOT/tools/exclude.txt"
echo "particles.png" >> "$PROJECT_ROOT/tools/exclude.txt"
echo "terrain.png" >> "$PROJECT_ROOT/tools/exclude.txt"
echo ".DS_Store" >> "$PROJECT_ROOT/tools/exclude.txt"

# 5. Run directory diff comparing your clean backup straight against your active workspace path
diff -Naurw -X "$PROJECT_ROOT/tools/exclude.txt" "$PROJECT_ROOT/clean_src/net.minecraft" "$PROJECT_ROOT/src/net/minecraft" > "$PROJECT_ROOT/patches/mod_changes.patch" || true

# 6. Clean up the temporary exclusion file
rm -f "$PROJECT_ROOT/tools/exclude.txt"

echo "✅ Smart patch successfully generated inside the /patches/ folder!"
