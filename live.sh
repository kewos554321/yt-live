#!/bin/bash
source .env
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"
STREAM_KEY="$YT_STREAM_KEY"

while true; do
  # echo "📥 Fetching videos..."
  # bash fetch_videos.sh

  for file in ./videos/*.mp4; do
    echo "▶️ Streaming $file"
    ffmpeg -re -i "$file" -c:v libx264 -preset veryfast -maxrate 3000k \
      -bufsize 6000k -pix_fmt yuv420p -g 60 -c:a aac -b:a 160k \
      -f flv "$YOUTUBE_URL/$STREAM_KEY"
  done

  echo "🔁 Restarting stream loop..."
done
