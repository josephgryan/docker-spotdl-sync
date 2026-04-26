#!/bin/sh
set -e

SYNC_INTERVAL=${SYNC_INTERVAL:-7200}
THREADS=${THREADS:-4}
PING_JELLYFIN=${PING_JELLYFIN:-false}

ping_jellyfin() {
  if [ "$PING_JELLYFIN" = "true" ]; then
    if [ -z "$JELLYFIN_URL" ] || [ -z "$JELLYFIN_TOKEN" ]; then
      echo "PING_JELLYFIN is true but JELLYFIN_URL or JELLYFIN_TOKEN is not set, skipping..."
      return
    fi
    echo "Notifying Jellyfin to scan library..."
    curl -s -X POST "${JELLYFIN_URL}/Library/Refresh" \
      -H "Authorization: MediaBrowser Token=${JELLYFIN_TOKEN}" \
      && echo "Jellyfin scan triggered." \
      || echo "Jellyfin ping failed, continuing anyway."
  fi
}

sync_playlists() {
  echo "$PLAYLISTS" | tr ',' '\n' | while IFS= read -r entry; do
    entry=$(echo "$entry" | tr -d '[:space:]')
    name=$(echo "$entry" | cut -d':' -f1)
    playlist=$(echo "$entry" | cut -d':' -f2-)

    cd /music
    mkdir -p "Playlists/${name}" .spotdl

    echo "Syncing playlist: $name"

    spotdl sync "$playlist" \
      --threads "$THREADS" \
      --save-file ".spotdl/${name}.spotdl" \
      --m3u "/music/${name}.m3u" \
      --output "Playlists/${name}/{list-position} - {artists} - {title}.{output-ext}" \
      --format mp3
  done
}

while true; do
  sync_playlists
  ping_jellyfin
  echo "Sync complete. Sleeping ${SYNC_INTERVAL}s..."
  sleep "$SYNC_INTERVAL"
done