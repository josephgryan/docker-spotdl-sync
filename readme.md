## function
provides a way for people who host media servers to sync their spotify playlist(s) in a functional, and easy way.

currently supports jellyfin, navidrome, and standalone (no media server, direct sync and play.) operations.

jellyfin suports pinging for sync but is not recomended for longterm use due to it creating an extra "libary" folder on your jellyfin instances homepages if the music libary is enabled. this is what the container was first tested on. it syncs metadata so it has genere support but the album suport is lacking, just using the playlists as albums.

navidrome is the best suported, currently what its tested agenst, unlike jellyfin it dose not suport sorting by genere but dose properly add albums.

passes 2 times per run. once via youtube music, and once via youtube. this is to make sure you get the best matches and quality when possible.

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

## Support

The best way to report a problem is via GitHub issues.

If I do not respond within 3~ days you may email me at Joseph.G.Ryan@protonmail.com, I check this email daily.

For user support not pertaining to bugs and things I must fix you are on your own or at the will of the community. Exception for questions from (possible) contributors, they may request via GitHub issues with the questions label.

## Contributing and Requests

Requests for new features can be added via GitHub issues with the appropriate label.

Pull requests are welcome, please make sure that the pull is up to date with the repo, if I don't respond within 3~ days you may directly contact me at Joseph.G.Ryan@protonmail.com.

For security issues if any even happen or issues effecting other software, email me immediately and directly at Joseph.G.Ryan@protonmail.com as well as filing a GitHub issue and a pull request if you have a fix.

## Current Plans

Add author and album support.

Smooth out bugs with different media server programs.

Smooth out bugs relating to unexpected behavior.

Embed better metadata and fix metadata for the media servers.

Imported cover image?

## License

General Public License v3.0. Not much else to say, if you really want to make a fork or something you must use this in your project, and you may redistribute, modify, copy, edit, and install freely.