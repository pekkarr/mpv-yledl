# mpv-yledl

*mpv-yledl* plugin allows you to watch YLE Areena in mpv. It uses [yle-dl](https://aajanki.github.io/yle-dl/) to parse the web page and get the stream URL.

## Installation

- Install [yle-dl](https://aajanki.github.io/yle-dl/).
- Copy `yledl_hook.lua` to your mpv user scripts directory (`~/.config/mpv/scripts/` on *NIX systems or `C:/Users/Username/AppData/Roaming/mpv/scripts/` on Windows).

## Usage

Pass the YLE Areena web page URL to mpv. For example:

`mpv https://areena.yle.fi/1-631348`

## License

Copyright 2021 Pekka Ristola

License: GPLv3
