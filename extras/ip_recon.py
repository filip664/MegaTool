#!/usr/bin/env python3
# MULTIOFALL :: SKID LAB :: ip recon
import json
import socket
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
    import requests
except Exception:
    requests = None

R = "\033[0m"
DIM = "\033[38;5;240m"
GRN = "\033[38;5;46m"
CYN = "\033[38;5;231m"
MAG = "\033[38;5;88m"
RED = "\033[38;5;196m"
YEL = "\033[38;5;220m"


def line(k, v, color=CYN):
    print(f"  {DIM}{k:<14}{R} {color}{v}{R}")


def local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return "n/a"


def fetch(url, timeout=6):
    if requests is None:
        return None
    try:
        r = requests.get(url, timeout=timeout, headers={"User-Agent": "MultiOfAll/2.0"})
        if r.status_code == 200:
            return r.json()
    except Exception:
        return None
    return None


def main():
    print()
    print(f"  {MAG}┌──────────────────────────────────────────────┐{R}")
    print(f"  {MAG}│{R}  {CYN}IP RECON :: know thy own attack surface{R}    {MAG}│{R}")
    print(f"  {MAG}└──────────────────────────────────────────────┘{R}")
    print()

    line("hostname", socket.gethostname())
    line("local ip", local_ip())
    try:
        line("lan dns", socket.gethostbyname(socket.gethostname()))
    except Exception:
        pass
    print()

    print(f"  {DIM}querying the outside world ...{R}")
    data = fetch("http://ip-api.com/json/?fields=status,country,regionName,city,zip,isp,org,as,query,timezone")
    if data and data.get("status") == "success":
        line("public ip", data.get("query"), GRN)
        line("country", data.get("country"), YEL)
        line("region", data.get("regionName"), YEL)
        line("city", data.get("city"), YEL)
        line("isp", data.get("isp"), CYN)
        line("org", data.get("org"), CYN)
        line("timezone", data.get("timezone"), DIM)
    else:
        alt = fetch("https://ipinfo.io/json")
        if alt and alt.get("ip"):
            line("public ip", alt.get("ip"), GRN)
            line("country", alt.get("country", "?"), YEL)
            line("region", alt.get("region", "?"), YEL)
            line("city", alt.get("city", "?"), YEL)
            line("org", alt.get("org", "?"), CYN)
            line("timezone", alt.get("timezone", "?"), DIM)
        else:
            print(f"  {RED}offline or the API is having a bad day.{R}")

    print()
    print(f"  {DIM}this is YOUR ip, not the target's. calm down.{R}")
    print()
    input(f"  {DIM}press ENTER to return to base{R}")


if __name__ == "__main__":
    main()
