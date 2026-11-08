#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: hollywood hack simulator
import os
import random
import sys
import time

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
RED = "\033[38;5;196m"
CYN = "\033[38;5;231m"
MAG = "\033[38;5;88m"
YEL = "\033[38;5;220m"


def clear():
    os.system("cls" if os.name == "nt" else "clear")


def slow(text, color=GRN, delay=0.012):
    for ch in text:
        sys.stdout.write(color + ch + R)
        sys.stdout.flush()
        time.sleep(delay)
    sys.stdout.write("\n")


def bar(label, seconds, color=GRN, width=34):
    sys.stdout.write(f"{DIM}[{R}{color}{label}{R}{DIM}]{R} ")
    sys.stdout.flush()
    for _ in range(width):
        sys.stdout.write(color + "█" + R)
        sys.stdout.flush()
        time.sleep(seconds / width)
    sys.stdout.write("  " + color + "OK" + R + "\n")


def main():
    clear()
    target = "the mainframe"
    if len(sys.argv) > 1:
        target = " ".join(sys.argv[1:])
    else:
        try:
            t = input(f"{MAG}target{R} > ").strip()
            if t:
                target = t
        except EOFError:
            pass

    print()
    slow("  initializing exploit framework ................................", DIM, 0.004)
    time.sleep(0.25)
    print(f"  {DIM}target locked:{R} {RED}{target}{R}  {DIM}(probably a toaster){R}")
    print()

    ip = ".".join(str(random.randint(1, 254)) for _ in range(4))
    steps = [
        ("resolving hostname", 0.35, CYN),
        (f"bypassing firewall @ {ip}", 0.55, YEL),
        ("escalating privileges", 0.40, MAG),
        ("injecting payload.exe", 0.50, RED),
        ("downloading 8GB of RAM", 0.60, GRN),
        ("brute forcing the mainframe", 0.55, CYN),
        ("encrypting the encryption", 0.45, MAG),
    ]
    for label, secs, col in steps:
        bar(label, secs, col)

    print()
    for i in range(6):
        line = " ".join(
            "%02X" % random.randint(0, 255) for _ in range(18)
        )
        print(f"  {DIM}0x{random.randint(0, 0xFFFF):04X}{R}  {GRN}{line}{R}")
        time.sleep(0.06)

    print()
    fake = [
        f"{RED}[!]{R} 5,213,882 accounts exposed",
        f"{RED}[!]{R} nuclear launch codes: nice try, fed",
        f"{YEL}[?]{R} deleting browser history (the real objective)",
    ]
    for f in fake:
        print("  " + f)
        time.sleep(0.18)

    print()
    slow("  ACCESS GRANTED", GRN, 0.05)
    time.sleep(0.6)
    print()
    slow("  ... just kidding. nothing happened.", DIM, 0.02)
    slow("  you just pressed buttons in a python script. touch grass, legend.", DIM, 0.012)
    print()
    input(f"  {DIM}press ENTER to return to base{R}")


if __name__ == "__main__":
    main()
