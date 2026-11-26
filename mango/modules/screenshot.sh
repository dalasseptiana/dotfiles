#!/bin/sh

# 1. Define save paths
save_dir="$HOME/screenshots"
mkdir -p "$save_dir"
filename="screenshot_$(date +%Y%m%d_%H%M%S).png"
filepath="$save_dir/$filename"

case "$1" in
    "area")
        # Run slurp for region select, then grim captures it
        if ! zone=$(slurp 2>/dev/null); then
            exit 1 # User canceled selection
        fi
        grim -g "$zone" "$filepath"
        ;;
    "full")
        # Capture the whole screen instantly
        grim "$filepath"
        ;;
    *)
        echo "Usage: $0 {area|full}"
        exit 1
        ;;
esac

# 3. Send system popup notification with preview
notify-send -i "$filepath" "Screenshot Saved" "Location: $save_dir/$filename"
