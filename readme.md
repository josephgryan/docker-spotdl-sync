## Install
Put this into a new compose file or add it to your existing stack and configure:

```yaml
services:
  spotdl-sync:
    image: ghcr.io/joseph-ryan8/docker-spotdl-sync:latest
    container_name: spotdl-sync
    volumes:
      # set /data/media/music to whatever you would like
      - /data/media/music:/music
    environment:
      # playlists in the format of name:url,name:url and so on
      - PLAYLISTS=name:https://open.spotify.com/playlist/id,name:https://open.spotify.com/playlist/id
      # if you want it to ping jellyfin when done, configure below, otherwise set to false
      - PING_JELLYFIN=true
      - JELLYFIN_URL=http://192.168.1.100:8096
      - JELLYFIN_TOKEN=yourtoken
      - THREADS=4
      - SYNC_INTERVAL=7200
    restart: unless-stopped
```