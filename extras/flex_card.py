#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: skid flex card
import random
import secrets
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
YEL = "\033[38;5;220m"
BLU = "\033[38;5;196m"

HANDLES = [
    "xX_skidmaster_Xx", "nullbyte", "0xDEADBEEF", "root@nowhere",
    "kernel_panic", "byte_me_69", "segfault_sam", "zero_day_zane",
    "sudo_rm_rf", "script_kiddie_9000", "hexadecimal_hank", "nullptr",
]
RANKS = [
    "SCRIPT KIDDIE", "ELITE HACKERMAN", "CYBER NINJA", "PACKET LORD",
    "TERMINAL GOBLIN", "ROOT ACCESS ENJOYER", "CERTIFIED MENACE",
    "WIRESHARK WIZARD", "LAN PARTY LEGEND",
]


def bar(pct, width=22, color=GRN):
    filled = int(pct / 100 * width)
    return color + "█" * filled + DIM + "░" * (width - filled) + R


def main():
    handle = random.choice(HANDLES)
    rank = random.choice(RANKS)
    uid = secrets.token_hex(4).upper()
    ip = ".".join(str(random.randint(1, 254)) for _ in range(4))
    skills = [
        ("python", random.randint(35, 99)),
        ("networking", random.randint(20, 95)),
        ("social engineering", random.randint(60, 100)),
        ("opsec", random.randint(2, 40)),
        ("touch grass", random.randint(0, 9)),
    ]

    print()
    print(f"  {MAG}╔══════════════════════════════════════════════════╗{R}")
    print(f"  {MAG}║{R}  {CYN}SKID FLEX CARD{R}          {DIM}// verified by nobody //{R}  {MAG}║{R}")
    print(f"  {MAG}╠══════════════════════════════════════════════════╣{R}")
    print(f"  {MAG}║{R}  {DIM}handle{R}   {YEL}{handle:<36}{R} {MAG}║{R}")
    print(f"  {MAG}║{R}  {DIM}rank{R}     {RED}{rank:<36}{R} {MAG}║{R}")
    print(f"  {MAG}║{R}  {DIM}uid{R}      {CYN}0x{uid}{R}                              {MAG}║{R}")
    print(f"  {MAG}║{R}  {DIM}ip{R}       {GRN}{ip:<36}{R} {MAG}║{R}")
    print(f"  {MAG}╠══════════════════════════════════════════════════╣{R}")
    for name, pct in skills:
        color = GRN if pct > 70 else (YEL if pct > 40 else RED)
        print(f"  {MAG}║{R}  {DIM}{name:<18}{R} {bar(pct, 22, color)} {color}{pct:>3}%{R} {MAG}║{R}")
    print(f"  {MAG}╠══════════════════════════════════════════════════╣{R}")
    print(f"  {MAG}║{R}  {DIM}aura{R}      {MAG}{'∞ (unverified)':<36}{R} {MAG}║{R}")
    print(f"  {MAG}║{R}  {DIM}warning{R}   {RED}{'extremely mid':<36}{R} {MAG}║{R}")
    print(f"  {MAG}╚══════════════════════════════════════════════════╝{R}")
    print()
    print(f"  {DIM}screenshot it, post it, let the timeline know.{R}")
    print()
    input(f"  {DIM}press ENTER to return to base{R}")


if __name__ == "__main__":
    main()
