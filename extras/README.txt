MULTIOFALL :: SKID LAB
======================

Extra scripts bundled with the menu (options 11-17).
They run with runtime\python\python.exe and match the dark red theme.

  11  matrix_rain.py    red matrix rain. press ctrl+c to bail out.
  12  hack_sim.py       cinematic fake hack. asks for a target name.
  13  pass_forge.py     strong passwords + passphrases, copies to clipboard.
  14  ip_recon.py       your public/local ip, isp and city (uses ip-api.com).
  15  ascii_forge.py    turns text into big figlet art (red gradient).
  16  flex_card.py      fake "elite hacker" id card. screenshot material.
  17  troll_bsod.py     fake bsod prank. harmless, exits on its own.

Notes
-----
- Everything here is local and safe. ip_recon is the only one that talks
  to the internet (it looks up YOUR ip).
- hack_sim, flex_card and troll_bsod are jokes, not actual tools.
- Run one by hand:
    runtime\python\python.exe extras\matrix_rain.py
- Add a new script: drop it in this folder and wire it into MultiOfAll.bat
  (the SKID LAB block in the $script:Tools array).
