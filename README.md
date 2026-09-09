# __EMOJI__ Omarchy Raiders

An [Omarchy](https://omarchy.org) theme. __ONE_LINE_PITCH__
Dark first, readable always.

![Desktop preview](preview.png)

## ✨ What you get

- **Palette** __PALETTE_SENTENCE__ Every colour clears its contrast target on
  every background — body text sits near __FG_RATIO__:1, and `muted`, the grey
  used for code comments, holds at __MUTED_RATIO__:1 instead of the usual
  3-ish.
- **Everything themed at once**: terminals (foot, Alacritty, Kitty, Ghostty),
  Neovim, btop, Helix, the Omarchy bar, launcher, notifications, lock screen,
  Chromium, VS Code, Obsidian, Claude Code, and the keyboard backlight.
- **Window borders** __BORDER_SENTENCE__
- **__N__ 4K wallpapers** __WALLPAPER_SENTENCE__
- **Optional extras**: __EXTRAS_SENTENCE__

## 📦 Install

```bash
omarchy theme install https://github.com/itsMattGuenther/omarchy-omarchy-raiders-theme.git
```

The theme is applied right away. Later, switch with:

```bash
omarchy theme set omarchy-raiders
omarchy theme bg next        # cycle wallpapers
```

## 🎨 Wallpapers

![Wallpapers](docs/wallpapers.jpg)

__N__ variants live in `backgrounds/`, all 3840x2160. They sort by filename, so
the numbered prefixes decide the order `omarchy theme bg next` walks. Add your
own next to them, or drop extra images into
`~/.config/omarchy/backgrounds/omarchy-raiders/` to keep them out of the theme folder.

## 🖼️ The art

![The theme's Braille art](docs/preview-art.png)

__ART_SENTENCE__

Greeting you in every new terminal:

![Terminal greeting](docs/preview-greeting.png)

And on the About screen, sized so Omarchy's own window measurement fits around
it:

![About screen](docs/preview-about.png)

Both live in `extras/art/` as plain text, with the SVG sources next to them so
you can redraw or resize them.

## 🎵 cliamp

![cliamp in the Omarchy Raiders theme](docs/preview-cliamp.png)

A matching theme for the [cliamp](https://github.com/omacom-io/cliamp) music
player. The theme hook switches cliamp to it while Omarchy Raiders is active and puts
your previous cliamp theme back when you switch away.

## 🔐 The lock screen

The lock screen (Super+Escape) shows a blurred copy of whichever wallpaper you
are on, with the theme's colours on the password box. That is how Omarchy
builds it, and no theme can put its own artwork there.

## 👾 Extras (optional)

Omarchy cannot install the art, the greeting or the cliamp theme from a theme
repo, so there is a one-shot script:

```bash
~/.config/omarchy/themes/omarchy-raiders/extras/install.sh
```

What it changes:

- copies files into `~/.config/omarchy-raiders/` and `~/.config/cliamp/themes/`
- adds one marked block at the end of `~/.bashrc` (a backup is kept as
  `.bashrc.bak.omarchy-raiders`)
- installs a theme hook, `omarchy-raiders-theme-set.sh`, that switches cliamp and the
  About logo whenever this theme is active, and puts both back when you pick
  another theme

The hook is named after the theme rather than `theme-set.sh`, so it sits
alongside other themes' hooks instead of overwriting them.

The greeting and the About art only show while this theme is the active one,
so other themes are left alone.

To remove all of it:

```bash
~/.config/omarchy/themes/omarchy-raiders/extras/install.sh --uninstall
```

## 🛠️ Hacking on it

- `colors.toml` is the whole palette. Everything else is generated from it.
- The Braille art is generated from `extras/art/*.svg`. Edit the vectors, then
  re-run the converter at the same character width to keep the proportions.

## 🙏 Credits

- __CREDITS__
- Built on Omarchy's theme system by DHH and the Omarchy community.

## 🤝 Contributing

I'd gladly take help from anyone who wants to iterate on this: better art,
palette tweaks, new extras, anything. Open an issue or a pull request. I'm here
for the community <3

## ⚖️ License

MIT, see `LICENSE`.
