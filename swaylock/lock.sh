#!/bin/bash

original_dir="$(pwd)"
cd "$(dirname "$0")" || exit

# Take screenshot
grim -t jpeg screen.jpg

# Get logo path, or pick a random icon
if [[ -n "$2" ]]; then
  cd "$original_dir" || exit
  image=$(realpath "$2")
  cd "$(dirname "$0")" || exit
else
  image="icons/$(shuf -i0-2 -n1).png"
fi

# Ensure the selected image exists
if [[ ! -f "$image" ]]; then
  image="icons/default.png"  # Fallback
fi

# Remove old overlay image safely
rm -f logo-ed_screen.png

# Default blur intensity
blur_strength="${1:-199}"

# Generate blurred background with logo overlay
ffmpeg -i screen.jpg -i "$image" -filter_complex \
  "[0:v] gblur=sigma=$blur_strength [blurred]; \
   [blurred][1:v] overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" \
  -y logo-ed_screen.png

# Ensure pywal colors are available
if [[ -f "$HOME/.cache/wal/colors.sh" ]]; then
  source "$HOME/.cache/wal/colors.sh"
else
  echo "Error: colors.sh not found!" >&2
  exit 1
fi

# Ensure background image exists before locking
if [[ ! -f "$HOME/.config/swaylock/logo-ed_screen.png" ]]; then
  echo "Error: Background image generation failed!" >&2
  exit 1
fi

# Launch swaylock
swaylock \
  --image "$HOME/.config/swaylock/logo-ed_screen.png" \
  --daemonize \
  --indicator-radius 160 \
  --indicator-thickness 20 \
  --inside-color 00000000 \
  --inside-clear-color 00000000 \
  --inside-ver-color 00000000 \
  --inside-wrong-color 00000000 \
  --key-hl-color "$color1" \
  --bs-hl-color "$color2" \
  --ring-color "$background" \
  --ring-clear-color "$color2" \
  --ring-wrong-color "$color5" \
  --ring-ver-color "$color3" \
  --line-uses-ring \
  --line-color 00000000 \
  --font 'Iosevka Nerd Font:style=Thin,Regular 40' \
  --text-color 00000000 \
  --text-clear-color 00000000 \
  --text-wrong-color 00000000 \
  --text-ver-color 00000000 \
  --separator-color 00000000
