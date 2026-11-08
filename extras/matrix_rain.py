#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: matrix rain
import os
import random
import shutil
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

HIDE = "\033[?25l"
SHOW = "\033[?25h"
CLEAR = "\033[2J\033[H"
RESET = "\033[0m"

DIM = "\033[38;5;52m"
MID = "\033[38;5;124m"
HOT = "\033[38;5;196m"
HEAD = "\033[38;5;231m"
WARN = "\033[38;5;196m"

CHARS = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホ0123456789ABCDEFｱｲｳｴｵ"


def at(row, col):
    return f"\033[{row};{col}H"


def main():
    w, h = shutil.get_terminal_size((110, 34))
    w = max(40, min(w, 200))
    h = max(12, min(h, 60))

    y = [random.randint(-h, 0) for _ in range(w)]
    spd = [random.uniform(0.35, 1.0) for _ in range(w)]
    ln = [random.randint(5, 22) for _ in range(w)]

    sys.stdout.write(HIDE + CLEAR)
    sys.stdout.flush()

    end = time.time() + 18.0
    tick = 0
    try:
        while time.time() < end:
            out = []
            for c in range(w):
                if random.random() > spd[c]:
                    continue
                y[c] += 1
                if y[c] > h + ln[c]:
                    y[c] = random.randint(-12, 0)
                    spd[c] = random.uniform(0.35, 1.0)
                    ln[c] = random.randint(5, 22)
                head = y[c]
                if 1 <= head <= h:
                    out.append(at(head, c + 1) + HEAD + random.choice(CHARS))
                tail = head - ln[c]
                if 1 <= tail <= h:
                    out.append(at(tail, c + 1) + MID + random.choice(CHARS))
                fade = tail - random.randint(2, 8)
                if 1 <= fade <= h:
                    out.append(at(fade, c + 1) + DIM + random.choice(CHARS))
            if out:
                sys.stdout.write("".join(out))
                sys.stdout.flush()

            tick += 1
            if tick % 90 == 0:
                msg = "  wake up, operator ... follow the white rabbit  "
                col = max(1, (w - len(msg)) // 2)
                sys.stdout.write(at(2, col) + WARN + msg + RESET + at(h, 1))
                sys.stdout.flush()

            time.sleep(0.028)
    except KeyboardInterrupt:
        pass
    finally:
        sys.stdout.write(RESET + CLEAR + SHOW)
        sys.stdout.write(at(2, 2) + MID + "signal lost." + RESET + "\r\n")
        sys.stdout.flush()


if __name__ == "__main__":
    main()
