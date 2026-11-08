#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: password forge
import os
import secrets
import string
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

R = "\033[0m"
DIM = "\033[38;5;240m"
GRN = "\033[38;5;46m"
CYN = "\033[38;5;231m"
MAG = "\033[38;5;88m"
RED = "\033[38;5;196m"

LOWER = string.ascii_lowercase
UPPER = string.ascii_uppercase
DIGIT = string.digits
SYMBO = "!@#$%^&*()-_=+[]{};:,.?"

WORDS = [
    "shadow", "neon", "cipher", "rogue", "vortex", "glitch", "phantom",
    "razor", "matrix", "viper", "ghost", "turbo", "lunar", "crimson",
    "zero", "hellfire", "blackout", "overdrive", "skid", "kernel",
]


def copy(text):
    try:
        import tkinter
        root = tkinter.Tk()
        root.withdraw()
        root.clipboard_clear()
        root.clipboard_append(text)
        root.update()
        root.destroy()
        return True
    except Exception:
        return False


def strong(n, symbols=True):
    pool = LOWER + UPPER + DIGIT + (SYMBO if symbols else "")
    while True:
        p = "".join(secrets.choice(pool) for _ in range(n))
        if (
            any(c.islower() for c in p)
            and any(c.isupper() for c in p)
            and any(c.isdigit() for c in p)
            and (not symbols or any(c in SYMBO for c in p))
        ):
            return p


def passphrase(n=4):
    return "-".join(secrets.choice(WORDS) for _ in range(n)) + "-" + str(secrets.randbelow(9000) + 1000)


def entropy(p):
    pool = 0
    if any(c.islower() for c in p):
        pool += 26
    if any(c.isupper() for c in p):
        pool += 26
    if any(c.isdigit() for c in p):
        pool += 10
    if any(not c.isalnum() for c in p):
        pool += len(SYMBO)
    import math
    return len(p) * (math.log2(pool) if pool else 0)


def main():
    print()
    print(f"  {MAG}┌──────────────────────────────────────────────┐{R}")
    print(f"  {MAG}│{R}  {CYN}PASSWORD FORGE :: make it hurt to guess{R}      {MAG}│{R}")
    print(f"  {MAG}└──────────────────────────────────────────────┘{R}")
    print()

    try:
        raw = input(f"  {DIM}length{R} [24] > ").strip()
        n = int(raw) if raw else 24
    except (ValueError, EOFError):
        n = 24
    n = max(8, min(n, 128))

    try:
        raw = input(f"  {DIM}how many{R} [5] > ").strip()
        count = int(raw) if raw else 5
    except (ValueError, EOFError):
        count = 5
    count = max(1, min(count, 25))

    print()
    for i in range(1, count + 1):
        p = strong(n, symbols=(i % 2 == 0))
        e = entropy(p)
        color = GRN if e >= 100 else CYN
        print(f"  {DIM}{i:02d}{R}  {color}{p}{R}  {DIM}[{e:.0f} bits]{R}")

    print()
    phrase = passphrase()
    print(f"  {DIM}passphrase:{R} {GRN}{phrase}{R}  {DIM}(easy to remember, annoying to crack){R}")

    test = strong(16)
    print()
    print(f"  {DIM}clipboard:{R} ", end="")
    print(f"{GRN}copied a 16-char sample{R}" if copy(test) else f"{RED}not available{R}")

    print()
    input(f"  {DIM}press ENTER to return to base{R}")


if __name__ == "__main__":
    main()
