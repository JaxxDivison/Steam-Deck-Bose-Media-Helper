# Steam Deck Bose Media Helper

A small helper for using Bose Bluetooth headphone controls with YouTube Music in Chrome on Steam Deck Gaming Mode.

I made this because I wanted to control my music while playing games without having to switch back to Chrome every time.

## Features

- Works with a Steam Deck running SteamOS
- Designed for Bose QuietComfort headphones
- Helps forward Bluetooth media controls
- Intended for YouTube Music in Google Chrome
- Runs as a user service
- Doesn't require disabling SteamOS read-only mode
- Includes status checks and an uninstall command

## Installation

1. Download `steamdeck-bose-media-helper.sh`.
2. Switch to Desktop Mode.
3. Open Konsole in the folder where you saved the file.
4. Run:

```bash
bash steamdeck-bose-media-helper.sh install
```

Open Chrome, go to [YouTube Music](https://music.youtube.com), and start playing something. Switch back to Gaming Mode and test your headphone controls.

## Commands

Check whether the helper is running:

```bash
bash steamdeck-bose-media-helper.sh status
```

Run a diagnostic check:

```bash
bash steamdeck-bose-media-helper.sh test
```

Uninstall it:

```bash
bash steamdeck-bose-media-helper.sh uninstall
```

## Notes

You'll need `mpris-proxy` available on your system for the helper to install.

Which controls work depends on your headphones, Bluetooth setup, and Chrome. Volume buttons may already work through SteamOS, and double-press skipping depends on how your headphones send media commands.

This is a small personal project. Feel free to report bugs or suggest improvements!


