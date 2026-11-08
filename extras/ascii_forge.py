#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: ascii forge
import random
import sys

try:
    import colorama
    colorama.just_fix_windows_console()
except Exception:
    pass

try:
    if not sys.stdout.isatty():
        sys.stdout.reconfigure(errors="replace")
except Exception:
    pass

try:
    from pyfiglet import Figlet, FigletFont
except Exception:
    Figlet = None

R = "\033[0m"
DIM = "\033[38;5;240m"
GRN = "\033[38;5;46m"
CYN = "\033[38;5;231m"
MAG = "\033[38;5;88m"
RED = "\033[38;5;196m"
YEL = "\033[38;5;220m"

FONTS = [
    "Bloody", "ANSI Shadow", "Slant", "Doom", "Big", "Standard",
    "Small", "Block", "Banner3-D", "Cyberlarge", "Elite", "Ghost",
    "Speed", "Star Wars", "Sub-Zero", "Tinker-Toy", "Varsity",
]

GRADIENT = [88, 124, 160, 196, 203, 210, 217, 224, 231, 224, 217, 210, 203, 196, 160, 124]


def paint(text):
    out = []
    i = 0
    for ln in text.splitlines():
        buf = []
        for ch in ln:
            if ch == " ":
                buf.append(ch)
            else:
                c = GRADIENT[i % len(GRADIENT)]
                buf.append(f"\033[38;5;{c}m{ch}{R}")
                i += 1
        out.append("".join(buf))
    return "\n".join(out)


def main():
    print()
    print(f"  {MAG}┌──────────────────────────────────────────────┐{R}")
    print(f"  {MAG}│{R}  {CYN}ASCII FORGE :: flex text, zero talent{R}       {MAG}│{R}")
    print(f"  {MAG}└──────────────────────────────────────────────┘{R}")
    print()

    if Figlet is None:
        print(f"  {RED}pyfiglet missing. run runtime\\repair-packages.bat{R}")
        input("  press ENTER ...")
        return

    text = ""
    try:
        text = input(f"  {DIM}text{R} [MULTI OF ALL] > ").strip()
    except EOFError:
        pass
    if not text:
        text = "MULTI OF ALL"

    avail = {f.lower(): f for f in FigletFont.getFonts()}
    fonts = [avail[f.lower()] for f in FONTS if f.lower() in avail] or sorted(avail.values())[:10]
    font = random.choice(fonts)

    print()
    print(f"  {DIM}font:{R} {YEL}{font}{R}")
    print()
    try:
        art = Figlet(font=font, width=240).renderText(text)
    except Exception:
        art = Figlet(font="standard", width=240).renderText(text)
    print(paint(art.rstrip()))

    print()
    print(f"  {DIM}tip: paste this into your bio and instantly gain +10 aura{R}")
    print()
    input(f"  {DIM}press ENTER to return to base{R}")


if __name__ == "__main__":
    main()
