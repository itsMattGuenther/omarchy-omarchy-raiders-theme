# Extras

Run `./extras/install.sh` from the repository root to install, or rerun it to
update existing extras. `./extras/install.sh --uninstall` removes them.

- `cliamp/omarchy-raiders.toml` — the music player theme.
- `art/greeting-art.ansi` — **Still listening**, a radio telescope and crescent
  printed in the theme palette when a terminal opens.
- `art/greeting-art.txt` — a plain text fallback for the greeting.
- `art/omarchy-raiders-ridge.txt` — **The listening station**, the About drawing.
  The filename stays the same for existing installations.
- `art/*.svg` — original, editable vector sources.
- `art/render.py` — the included SVG-to-Braille converter.
- `greeting.sh` — prints the artwork only in interactive Bash while this
  theme is active. It reads static files and starts no external programs.
- `../hooks/omarchy-raiders-theme-set.sh` — switches cliamp and the About logo
  with the theme and restores their previous state when switching away.

The installer copies files into `~/.config/omarchy-raiders/` and
`~/.config/cliamp/themes/`, adds a marked block to `~/.bashrc`, and installs
the theme hook. Reinstalling while the theme is active refreshes the art
without replacing the backup of your original About logo.

## The artwork

The greeting is a compact 56-column by 18-row drawing. The About piece is
64 columns by 24 rows, with a distant observatory and layered terrain.
Cream and cyan describe the instrument, muted blue marks the horizon, and
gold lights the feed and a single star. The forms use general astronomy
imagery; no game character, machine, logo, or screenshot is used.

The installer uses the plain About file so Omarchy's `wc -L` width
measurement stays accurate. fastfetch supplies its logo colour. A full-colour
`.ansi` version is also included for standalone viewing or a custom layout.
Each ANSI row resets its colour. Both variants have the same visible cells.

## Redrawing and previewing

From the repository root, with Python 3.11+, librsvg (`rsvg-convert`) and
ImageMagick (`magick`) available:

```bash
python3 extras/art/render.py
cat extras/art/greeting-art.ansi
cat extras/art/omarchy-raiders-ridge.ansi
fastfetch --logo-type file --logo extras/art/omarchy-raiders-ridge.txt
```

The converter writes both `.txt` and `.ansi` versions. Its SVG canvas uses
one unit per dot; a Braille cell is 2 by 4 dots. Keep the greeting at 112x72
and the About source at 128x96 to preserve the installed layouts. Leave the
background transparent and use the colours in `colors.toml`. These tools
are only needed to regenerate art; installation and startup use the
checked-in text files.

See [artwork provenance](../docs/artwork.md) for the creative process and
[the rendered preview](../docs/preview-art.png) for both installed styles.
