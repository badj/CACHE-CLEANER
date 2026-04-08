# rm -rf "/Users/[your mac user profile here]/Library/Application Support/stremio-server/stremio-cache/"* 2>/dev/null || true

#!/usr/bin/env bash

# =====================================================
# Stremio Cache Cleaner with Fireworks Animation Option
# =====================================================

TARGET="~/Library/Application Support/stremio-server/stremio-cache"

# Expand ~ to full path
TARGET=$(eval echo "$TARGET")

echo "TARGET DIRECTORY: $TARGET"
echo

# Safety checks
if [[ ! -d "$TARGET" ]]; then
    echo "Error: Directory does not exist: $TARGET"
    exit 1
fi

if [[ "$TARGET" == "/" || "$TARGET" == "/Users" || "$TARGET" == "$HOME" ]]; then
    echo "Error: Refusing to operate on a critical directory."
    exit 1
fi

# Show what's inside and total size before deletion
echo "CONTENTS OF STREMIO CACHE FOLDER:"
ls -lh "$TARGET" | head -20
if [[ $(find "$TARGET" -maxdepth 1 | wc -l) -gt 21 ]]; then
    echo "... (showing first 20 items, more exist)"
fi
echo

# Calculate current size in MB
SIZE_BEFORE=$(du -sm "$TARGET" 2>/dev/null | awk '{print $1}')
echo "CURRENT CACHE SIZE: ${SIZE_BEFORE} MB"
echo

# Optional extra confirmation (uncomment if you want double safety)
# read -p "Delete all contents of the cache folder? Type 'yes' to confirm: " confirmation
# if [[ "$confirmation" != "yes" ]]; then
#    echo "Operation aborted."
#    exit 0
# fi

echo "→ 🚀 DELETING CONTENTS OF: $TARGET"
echo "→ 🚨 REMOVAL IN PROGRESS..."
echo "→ 🧚 FILES/FOLDERS BEING DELETED:"

# List files as they are deleted (with size)
find "$TARGET" -mindepth 1 -exec du -sh {} \; | sed 's/^/  DELETING: /'

# Actually delete everything inside (but not the folder itself)
rm -rf "${TARGET}/"* "${TARGET}/".* 2>/dev/null

# Calculate size after deletion
SIZE_AFTER=$(du -sm "$TARGET" 2>/dev/null | awk '{print $1}')
# Calculate deleted amount
DELETED_MB=$((SIZE_BEFORE - SIZE_AFTER))

echo
echo "=========================================="
echo "→ ✅ STREMIO CACHE CLEANUP COMPLETE"
echo "→ 🗑  DELETED: ${DELETED_MB} MB"
echo "→ ✨ REMAINING CACHE SIZE AFTER CLEANUP: ${SIZE_AFTER} MB"
echo "→ 🍿 FOLDER: $TARGET"
echo "=========================================="

# === System disk space information ===
echo "OVERALL DISK SPACE ON YOUR MAC (MAIN DRIVE):"
echo

# Use df to get info about the main disk (usually /dev/disk1s5s1 or similar on macOS)
# Use the root filesystem '/' as reference
df -h / | tail -1 | awk '{
    printf "  TOTAL DISK SIZE:  %s\n", $2
    printf "  USED:             %s\n", $3
    printf "  FREE (REMAINING): %s\n", $4
    printf "  USED PERCENTAGE:  %s\n", $5
}'
# === Additional human-readable summary ===
FREE_SPACE=$(df -h / | tail -1 | awk '{print $4}')
echo
echo "YOU NOW HAVE APPROXIMATELY ${FREE_SPACE} OF FREE SPACE REMAINING ON YOUR MAIN DRIVE."
echo "=========================================="

# === Fireworks celebration with user choice ===
echo
echo -e "→ Fire some fireworks for the successful cleanup? 🎆 "
read -p "→ Type 'yes' or 'y' to fire fireworks - anything else to skip: " fireworks_choice

echo

if [[ "$fireworks_choice" =~ ^[Yy]([Ee][Ss])?$ ]]; then
    echo -e "→ 🎆  LAUNCHING FIREWORKS...  🎆"
    echo

    if command -v node >/dev/null 2>&1; then
        npx firew0rks fireworks 1 || true
    else
        echo "(Skipping fireworks - Node.js is not installed)"
        echo "You can install Node.js to enjoy the fireworks next time!"
    fi
else
    echo "→ Fireworks skipped. Hope you still enjoyed the cleanup! ✨"
fi

# === Thank you message with short pause===
echo
echo -e "→ THANKS FOR USING CACHE-CLEANER 🤙 "

# === Prompt to close the Terminal window ===
echo
read -p "→ 🏁 PRESS ANY KEY TO CLOSE THE TERMINAL WINDOW..." -n 1
echo

# Close Terminal or iTerm2 window
osascript -e 'tell application "Terminal" to close front window' >/dev/null 2>&1
osascript -e 'tell application "iTerm2" to close front window' >/dev/null 2>&1
# Fallback: if osascript fails (rare), just exit
exit 0
