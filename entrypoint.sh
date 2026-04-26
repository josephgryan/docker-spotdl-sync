#!/bin/sh
set -e

sync_playlists() {
  echo "$PLAYLISTS" | tr ',' '\n' | while IFS= read -r playlist; do
    playlist=$(echo "$playlist" | tr -d '[:space:]')
    clean_name=$(echo "$playlist" | sed 's|.*/playlist/||' | cut -d'?' -f1)
    output_dir="/music/Playlists/${clean_name}"

    mkdir -p "$output_dir" /music/.spotdl

    echo "Syncing playlist: $clean_name"

    spotdl sync "$playlist" \
      --threads 1 \
      --save-file "/music/.spotdl/${clean_name}.spotdl" \
      --m3u "/music/Playlists/${clean_name}.m3u" \
      --output "${output_dir}/{list-position} - {artists} - {title}.{output-ext}" \
      --format mp3
  done
}

while true; do
  sync_playlists
  echo "Sync complete. Sleeping 2 hours..."
  sleep 7200
done