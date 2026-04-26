#!/bin/sh
set -e

sync_playlists() {
  echo "$PLAYLISTS" | tr ',' '\n' | while IFS= read -r entry; do
    entry=$(echo "$entry" | tr -d '[:space:]')
    name=$(echo "$entry" | cut -d':' -f1)
    playlist=$(echo "$entry" | cut -d':' -f2-)

    cd /music
    mkdir -p "Playlists/${name}" .spotdl

    echo "Syncing playlist: $name"

    spotdl sync "$playlist" \
      --threads 4 \
      --save-file ".spotdl/${name}.spotdl" \
      --m3u "Playlists/${name}.m3u" \
      --output "Playlists/${name}/{list-position} - {artists} - {title}.{output-ext}" \
      --format mp3
  done
}

while true; do
  sync_playlists
  echo "Sync complete. Sleeping 2 hours..."
  sleep 7200
done