#!/bin/sh
set -e

sync_playlists() {
  echo "$PLAYLISTS" | tr ',' '\n' | while IFS= read -r entry; do
    entry=$(echo "$entry" | tr -d '[:space:]')
    name=$(echo "$entry" | cut -d':' -f1)
    playlist=$(echo "$entry" | cut -d':' -f2-)
    output_dir="/music/Playlists/${name}"

    mkdir -p "$output_dir" /music/.spotdl

    echo "Syncing playlist: $name"

    spotdl sync "$playlist" \
      --threads 1 \
      --save-file "/music/.spotdl/${name}.spotdl" \
      --m3u "/music/Playlists/${name}.m3u" \
      --output "${output_dir}/{list-position} - {artists} - {title}.{output-ext}" \
      --format mp3
  done
}

while true; do
  sync_playlists
  echo "Sync complete. Sleeping 2 hours..."
  sleep 7200
done