#!/bin/bash
set -e

# 1. Calculate paths using the terminal's location
TOOLS_DIR=$(pwd)
PROJECT_ROOT=$(cd "$TOOLS_DIR/.." && pwd)

echo "🧹 Resetting Minecraft source code to clean vanilla..."

# 2. Overwrite only the matching track trees to shield your root image assets
if [ -d "$PROJECT_ROOT/clean_src/net.minecraft" ]; then
    mkdir -p "$PROJECT_ROOT/src/net/minecraft"
    rsync -a --delete "$PROJECT_ROOT/clean_src/net.minecraft/" "$PROJECT_ROOT/src/net/minecraft/"
else
    echo "❌ Error: clean_src reference folders not found!"
    exit 1
fi

echo "🪵 Applying your mod patches..."
if [ -f "$PROJECT_ROOT/patches/mod_changes.patch" ]; then
    # Applies the patch relative directly to your active working directory package track
    patch -p1 -d "$PROJECT_ROOT/src/net/minecraft" < "$PROJECT_ROOT/patches/mod_changes.patch"
    echo "✅ Minecraft code successfully updated with patches!"
else
    echo "✅ No patch file found. Workspace left at clean vanilla."
fi
