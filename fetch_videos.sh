#!/bin/bash
VIDEO_DIR="./videos"
URL_FILE="./video_urls.txt"

rm -rf "$VIDEO_DIR"
mkdir -p "$VIDEO_DIR"

i=1
while read -r url; do
  filename="$VIDEO_DIR/video_$i.mp4"
  echo "⬇️ Downloading: $url → $filename"
  curl -L "$url" -o "$filename"
  ((i++))
done < "$URL_FILE"
