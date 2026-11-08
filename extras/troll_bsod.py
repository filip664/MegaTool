#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: troll mode (fake bsod)
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
WHT = "\033[38;5;231m"
DIM = "\033[38;5;245m"
RED = "\033[38;5;196m"
BLU = "\033[48;5;17m"


def main():
    os.system("cls" if os.name == "nt" else "clear")
    codes = ["0x000000EF", "0xDEADBEEF", "0x0000007B", "0xC000021A"]
    code = random.choice(codes)
    frames = ["*", "**", "***", "****", "*****", "******"]
    seconds = 7

    try:
        sys.stdout.write(BLU + WHT)
        sys.stdout.write("\n\n")
        print(" " * 4 + ":(")
        print()
        print(" " * 4 + "Your PC ran into a problem and needs to restart.")
        print(" " * 4 + "We're just collecting some error info, and then we'll")
        print(" " * 4 + "restart for you. (0% complete)")
        print()
        print(" " * 4 + "If you'd like to know more, you can search online later for")
        print(" " * 4 + f"this error: MULTIOFALL_SKID_DETECTED {code}")
        print()
        print(" " * 4 + "What failed: too_much_swag.sys")
        print()
        sys.stdout.flush()

        for pct in range(0, 101, 7):
            sys.stdout.write("\033[5;15H" + f"restart for you. ({pct}% complete)   ")
            sys.stdout.flush()
            time.sleep(0.35)

        sys.stdout.write("\033[5;15H" + "restart for you. (100% complete)   " + R)
        sys.stdout.write("\n")
        time.sleep(0.8)
        sys.stdout.write("\033[0m")
        os.system("cls" if os.name == "nt" else "clear")

        print()
        print(f"  {DIM}just kidding.{R}")
        print(f"  {DIM}your pc is fine. your dignity, however, is still compiling.{R}")
        print()
        input(f"  {DIM}press ENTER to return to base{R}")
    except KeyboardInterrupt:
        sys.stdout.write(R)


if __name__ == "__main__":
    main()
