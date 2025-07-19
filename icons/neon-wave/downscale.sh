#!/bin/bash

# Define the input file from the previous script's output
input_file="icon-1024.png" # Assuming the previous script generated output.png

# Define the output directory for downscaled images
output_dir="."
# mkdir -p "$output_dir" # Create the directory if it doesn't exist

# Define the desired sizes
sizes=(16 32 48 64 128 256 512)

# Set PNG compression quality: 9 for max compression level, 5 for adaptive filtering
# This is equivalent to -define png:compression-level=9 and -define png:compression-filter=5
# Adaptive filtering (-quality 05) is generally recommended for photos or complex images.
png_quality="05"

# Loop through each size and create a downscaled version
for size in "${sizes[@]}"; do
  output_filename="${output_dir}/icon-${size}.png"
  echo "Creating ${output_filename}..."

  convert "$input_file" \
    -filter LanczosSharp \
    -resize "${size}x${size}" \
    -quality "$png_quality" \
    "$output_filename"
done

echo "Downscaling complete. Images saved in the '${output_dir}' directory."
