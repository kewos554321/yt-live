#!/bin/bash
VIDEO_DIR="./videos"
URL_FILE="./video_urls.txt"

rm -rf "$VIDEO_DIR"
mkdir -p "$VIDEO_DIR"

i=1
while read -r url; do
  echo "url: $url"
  filename="$VIDEO_DIR/video_$i.mp4"
  echo "⬇️ Downloading: $url → $filename"

  if [[ "$url" =~ drive.google.com ]]; then
    # 取得檔案ID
    fileid=$(echo "$url" | sed -E 's/.*\/file\/d\/([^\/]+).*/\1/')
    echo "fileid: $fileid"
    # 先取得確認碼
    html=$(curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}")
    confirm=$(echo "$html" | perl -n -e 'print "$1\n" if /confirm=([^&]+)/' | head -n 1)
    if [[ -z "$confirm" ]]; then
      # confirm token 沒抓到，直接嘗試下載
      curl -Lb ./cookie "https://drive.google.com/uc?export=download&id=${fileid}" -o "$filename"
    else
      # 用確認碼下載檔案
      curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=${confirm}&id=${fileid}" -o "$filename"
    fi
    rm -f ./cookie
  else
    echo "Not a Google Drive URL"
    curl -L "$url" -o "$filename"
  fi

  ((i++))
done < "$URL_FILE"
