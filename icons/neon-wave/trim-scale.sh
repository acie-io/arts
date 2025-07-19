#!/bin/bash

# Define the input and output filenames
input_file="icon-1024-orig.png"
output_file="icon-1024.png"
temp_trimmed="temp-icon-1024-orig-trimmed.png" # Temporary file for the trimmed image
temp_squared="temp-icon-1024-orig-trimmed-squared.png" # Temporary file for the squared image

target_size=1024

# 1. Trim the image, preserve alpha channel and use a high-quality filter
convert "$input_file" \
  -alpha set \
  -fuzz 5% \
  -trim +repage \
  -define png:compression-level=1 \
  -define png:compression-strategy=1 \
  "$temp_trimmed"

# 2. Identify the dimensions of the trimmed image
read w h < <(identify -format "%w %h" "$temp_trimmed")

# 3. Calculate the maximum side for the square
if (( w > h )); then
  max_side=$w
else
  max_side=$h
fi

# 4. Extend the trimmed image to a square, ensuring transparency and quality
convert "$temp_trimmed" \
  -gravity center \
  -background none \
  -virtual-pixel transparent \
  -extent "${max_side}x${max_side}" \
  -define png:compression-level=1 \
  -define png:compression-strategy=1 \
  "$temp_squared"

# 5. Resize the squared image to the target size, prioritizing quality and using a specific filter
convert "$temp_squared" \
  -filter LanczosSharp \
  -resize "${target_size}x${target_size}" \
  -define png:compression-level=1 \
  -define png:compression-strategy=1 \
  "$output_file"

# 6. Clean up temporary files
rm "$temp_trimmed" "$temp_squared"
