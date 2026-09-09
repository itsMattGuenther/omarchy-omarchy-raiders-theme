#!/usr/bin/env python3
"""Regenerate Braille from original SVGs using Python, librsvg, and ImageMagick.

Each SVG unit is one Braille dot; a terminal cell contains 2 x 4 dots.
No photographs, generated wallpapers, or external artwork are used as input.
"""
from collections import Counter
from pathlib import Path
import subprocess
import tomllib
import xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
PALETTE = tomllib.loads((HERE.parent.parent / "colors.toml").read_text())
COLORS = [
    tuple(bytes.fromhex(PALETTE[name].lstrip("#")))
    for name in ("foreground", "muted", "blue", "magenta", "orange", "cyan", "yellow", "brown")
]
DOTS = ((0, 3), (1, 4), (2, 5), (6, 7))
RESET = "\x1b[0m"


def render(source: Path) -> None:
    root = ET.parse(source).getroot()
    width, height = int(root.attrib["width"]), int(root.attrib["height"])
    if width % 2 or height % 4:
        raise ValueError(f"{source.name}: dimensions must fit 2 x 4 Braille cells")
    png = subprocess.run(
        ["rsvg-convert", str(source)], check=True, capture_output=True
    ).stdout
    pixels = subprocess.run(
        ["magick", "png:-", "-depth", "8", "rgba:-"],
        input=png, check=True, capture_output=True,
    ).stdout
    if len(pixels) != width * height * 4:
        raise ValueError("Unexpected raster dimensions")

    plain_lines, color_lines = [], []
    for y in range(0, height, 4):
        cells = []
        for x in range(0, width, 2):
            bits, weights = 0, Counter()
            for dy in range(4):
                for dx in range(2):
                    offset = ((y + dy) * width + x + dx) * 4
                    r, g, b, alpha = pixels[offset:offset + 4]
                    if alpha < 72:
                        continue
                    bits |= 1 << DOTS[dy][dx]
                    nearest = min(COLORS, key=lambda c: sum((a - b) ** 2 for a, b in zip(c, (r, g, b))))
                    weights[nearest] += alpha
            color = weights.most_common(1)[0][0] if weights else None
            cells.append((chr(0x2800 + bits) if bits else " ", color))
        while cells and cells[-1][0] == " ":
            cells.pop()
        plain_lines.append("".join(char for char, _ in cells))
        line, current = "", None
        for char, color in cells:
            if color is not None and color != current:
                line += f"\x1b[38;2;{color[0]};{color[1]};{color[2]}m"
                current = color
            line += char
        color_lines.append(line + RESET)

    source.with_suffix(".txt").write_text("\n".join(plain_lines) + "\n", encoding="utf-8")
    source.with_suffix(".ansi").write_text("\n".join(color_lines) + "\n", encoding="utf-8")
    print(f"{source.stem}: {width // 2} columns x {height // 4} rows")


if __name__ == "__main__":
    for source in sorted(HERE.glob("*.svg")):
        render(source)
