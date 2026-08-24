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
    [ -z "$entry" ] && continue
    
    name=$(echo "$entry" | cut -d':' -f1)
    playlist=$(echo "$entry" | cut -d':' -f2-)

    cd /music
    mkdir -p "Playlists/${name}" .spotdl

    # DYNAMIC TEMPLATE CHECK:
    # If the URL contains "artist" or "album", use an album-sorted naming style.
    # Otherwise, assume it's a standard playlist and include the track positions cleanly.
    case "$playlist" in
      *artist*|*album*)
        echo "Configuring Discography template for: $name"
        OUTPUT_TEMPLATE="Playlists/${name}/{album}/{artists} - {title}.{output-ext}"
        ;;
      *)
        echo "Configuring Playlist template for: $name"
        OUTPUT_TEMPLATE="Playlists/${name}/{list-position} - {artists} - {title}.{output-ext}"
        ;;
    esac

    echo "Syncing collection: $name (round 1 - YouTube Music)"
    if ! spotdl sync "$playlist" \
      --threads "$THREADS" \
      --audio youtube-music \
      --ytm-data \
      --save-file ".spotdl/${name}.spotdl" \
      --output "$OUTPUT_TEMPLATE" \
      --format mp3; then
      echo "Round 1 (YouTube Music) failed for '$name', continuing to round 2..."
    fi

    echo "Syncing collection: $name (round 2 - YouTube fallback)"
    spotdl sync "$playlist" \
      --threads "$THREADS" \
      --save-file ".spotdl/${name}.spotdl" \
      --output "$OUTPUT_TEMPLATE" \
      --format mp3
  done
}

while true; do
  sync_playlists
  ping_jellyfin
  echo "Sync complete. Sleeping ${SYNC_INTERVAL}s..."
  sleep "$SYNC_INTERVAL"
done