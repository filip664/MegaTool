@echo off
setlocal
set "SELF=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$m='#'+'__PSSECTION__';$c=[IO.File]::ReadAllText($env:SELF);$i=$c.IndexOf($m);if($i -lt 0){exit 2};iex $c.Substring($i+$m.Length)"
exit /b %errorlevel%
#__PSSECTION__

$ErrorActionPreference = 'Stop'

trap {
    Write-Host ''
    Write-Host ('   [x] {0}' -f $_.Exception.Message) -ForegroundColor Red
    Read-Host '   press ENTER to close'
    exit 1
}

$root = Split-Path -Parent $env:SELF
try { $Host.UI.RawUI.WindowTitle = 'MultiOfAll v3.0 :: 0xSKID :: root@localhost' } catch { }
try {
    $Host.UI.RawUI.BackgroundColor = [ConsoleColor]::Black
    $Host.UI.RawUI.ForegroundColor = [ConsoleColor]::Gray
} catch { }

# --- bundled python runtime (portable, lives in .\runtime\python) ----------
$script:BundledPython = Join-Path $root 'runtime\python\python.exe'
if (-not (Test-Path -LiteralPath $script:BundledPython)) { $script:BundledPython = $null }

if ($script:BundledPython) {
    $pyDir = Split-Path -Parent $script:BundledPython
    $env:PATH = $pyDir + ';' + (Join-Path $pyDir 'Scripts') + ';' + $env:PATH
}
elseif (Test-Path -LiteralPath (Join-Path $root 'runtime\python\python.bat')) {
    $env:PATH = (Join-Path $root 'runtime\python') + ';' + $env:PATH
}

function Get-PythonExe {
    if ($script:BundledPython -and (Test-Path -LiteralPath $script:BundledPython)) {
        return $script:BundledPython
    }
    $cmd = Get-Command python -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

# ---------------------------------------------------------------------------
#  console setup
# ---------------------------------------------------------------------------
function Set-ConsoleSize {
    try {
        $raw = $Host.UI.RawUI
        $targetW = 120
        $targetH = 46
        $maxW = $raw.MaxPhysicalWindowSize.Width
        $maxH = $raw.MaxPhysicalWindowSize.Height
        $w = [Math]::Min($targetW, $maxW)
        $h = [Math]::Min($targetH, $maxH)
        if ($raw.BufferSize.Width -lt $w) {
            $raw.BufferSize = New-Object System.Management.Automation.Host.Size($w, [Math]::Max($raw.BufferSize.Height, $h))
        }
        if ($raw.BufferSize.Height -lt $h) {
            $raw.BufferSize = New-Object System.Management.Automation.Host.Size($raw.BufferSize.Width, $h)
        }
        if ($raw.WindowSize.Width -lt $w) {
            $raw.WindowSize = New-Object System.Management.Automation.Host.Size($w, $raw.WindowSize.Height)
        }
        if ($raw.WindowSize.Height -lt $h) {
            $raw.WindowSize = New-Object System.Management.Automation.Host.Size($raw.WindowSize.Width, $h)
        }
    } catch { }
}

$script:UseConsole = $true
try {
    if ([Console]::IsOutputRedirected) { $script:UseConsole = $false }
} catch { $script:UseConsole = $false }

$script:ConsoleWidth = 120

$script:Shadow = @(
    [ConsoleColor]::DarkRed,   [ConsoleColor]::Red,
    [ConsoleColor]::DarkRed,   [ConsoleColor]::DarkRed,
    [ConsoleColor]::Red,       [ConsoleColor]::DarkRed,
    [ConsoleColor]::Red,       [ConsoleColor]::DarkRed,
    [ConsoleColor]::Red
)

$script:Sparks = @(
    [ConsoleColor]::Red,       [ConsoleColor]::White,
    [ConsoleColor]::DarkRed,   [ConsoleColor]::Red,
    [ConsoleColor]::White,     [ConsoleColor]::DarkRed,
    [ConsoleColor]::Red,       [ConsoleColor]::White,
    [ConsoleColor]::DarkRed
)

$script:Taglines = @(
    '< all your tools in one arsenal :: v3.0 >',
    '< root access to the skid dimension :: v3.0 >',
    '< we do a little trolling :: v3.0 >',
    '< certified menace since birth :: v3.0 >',
    '< no thoughts, just payloads :: v3.0 >',
    '< keyboard goes brrr :: v3.0 >',
    '< the mainframe is a state of mind :: v3.0 >'
)

$script:Logo = @'
 ███▄ ▄███▓ █    ██  ██▓  ▄▄▄█████▓ ██▓    ▒█████    █████▒    ▄▄▄       ██▓     ██▓
▓██▒▀█▀ ██▒ ██  ▓██▒▓██▒  ▓  ██▒ ▓▒▓██▒   ▒██▒  ██▒▓██   ▒    ▒████▄    ▓██▒    ▓██▒
▓██    ▓██░▓██  ▒██░▒██░  ▒ ▓██░ ▒░▒██▒   ▒██░  ██▒▒████ ░    ▒██  ▀█▄  ▒██░    ▒██░
▒██    ▒██ ▓▓█  ░██░▒██░  ░ ▓██▓ ░ ░██░   ▒██   ██░░▓█▒  ░    ░██▄▄▄▄██ ▒██░    ▒██░
▒██▒   ░██▒▒▒█████▓ ░██████▒▒██▒ ░ ░██░   ░ ████▓▒░░▒█░        ▓█   ▓██▒░██████▒░██████▒
░ ▒░   ░  ░░▒▓▒ ▒ ▒ ░ ▒░▓  ░▒ ░░   ░▓     ░ ▒░▒░▒░  ▒ ░        ▒▒   ▓▒█░░ ▒░▓  ░░ ▒░▓  ░
░  ░      ░░░▒░ ░ ░ ░ ░ ▒  ░  ░     ▒ ░     ░ ▒ ▒░  ░           ▒   ▒▒ ░░ ░ ▒  ░░ ░ ▒  ░
░      ░    ░░░ ░ ░   ░ ░   ░       ▒ ░   ░ ░ ░ ▒   ░ ░         ░   ▒     ░ ░     ░ ░
       ░      ░         ░  ░        ░         ░ ░                   ░  ░    ░  ░    ░  ░
'@

# ---------------------------------------------------------------------------
#  eye candy
# ---------------------------------------------------------------------------
function Write-Rainbow {
    param([string]$Text, [ConsoleColor]$Color = [ConsoleColor]::DarkRed, [ConsoleColor]$Spark = [ConsoleColor]::Red)

    if (-not $script:UseConsole) {
        Write-Host $Text
        return
    }

    $n = $Text.Length
    try {
        for ($i = 0; $i -lt $n; $i++) {
            $ch = $Text[$i]
            if ($ch -ne ' ') {
                # sparse glitch highlights make the letters feel alive
                if (($i % 19) -eq 0 -or ($i % 31) -eq 0) {
                    [Console]::ForegroundColor = $Spark
                }
                else {
                    [Console]::ForegroundColor = $Color
                }
            }
            [Console]::Write($ch)
        }
        [Console]::WriteLine()
    } catch {
        Write-Host $Text
    }
    try { [Console]::ForegroundColor = [ConsoleColor]::Gray } catch { }
}

function Show-Banner {
    $lines = $script:Logo -split '\r?\n'

    $width = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $pad = [Math]::Max(0, [int](($script:ConsoleWidth - $width) / 2))

    Write-Host ''
    for ($r = 0; $r -lt $lines.Count; $r++) {
        $color = $script:Shadow[[Math]::Min($r, $script:Shadow.Count - 1)]
        $spark = $script:Sparks[[Math]::Min($r, $script:Sparks.Count - 1)]
        Write-Host (' ' * $pad) -NoNewline
        Write-Rainbow ($lines[$r].PadRight($width)) $color $spark
    }

    $tag = $script:Taglines[(Get-Random -Minimum 0 -Maximum $script:Taglines.Count)]
    $hex = -join (1..6 | ForEach-Object { '{0:X}' -f (Get-Random -Minimum 0 -Maximum 16) })
    $suffix = "  [0x$hex]"
    $tpad = [Math]::Max(0, [int](($script:ConsoleWidth - ($tag.Length + $suffix.Length)) / 2))
    Write-Host ((' ' * $tpad) + $tag) -NoNewline -ForegroundColor DarkGray
    Write-Host $suffix -ForegroundColor DarkRed
    Write-Host ''
}

function Show-Boot {
    $lines = @(
        @{ Tag = '!'; Text = 'cold boot :: multiofall kernel v3.0';        Color = 'Red'       },
        @{ Tag = '+'; Text = 'mounting encrypted volume /dev/skid';        Color = 'DarkGray'  },
        @{ Tag = '+'; Text = 'loading 10 arsenal modules';                 Color = 'White'     },
        @{ Tag = '+'; Text = 'arming 7 skid lab scripts';                  Color = 'White'     },
        @{ Tag = 'x'; Text = 'tracing route ... blocked by cloudflare';    Color = 'DarkRed'   },
        @{ Tag = '!'; Text = 'disabling safety features ... just kidding'; Color = 'DarkYellow'},
        @{ Tag = '+'; Text = 'operator verified :: welcome back, menace';  Color = 'Green'     }
    )

    Write-Host ''
    foreach ($l in $lines) {
        Write-Host '   [' -NoNewline -ForegroundColor DarkGray
        Write-Host $l.Tag -NoNewline -ForegroundColor Red
        Write-Host '] ' -NoNewline -ForegroundColor DarkGray
        Write-Host $l.Text -ForegroundColor $l.Color
        Start-Sleep -Milliseconds 75
    }

    Write-Host '   [' -NoNewline -ForegroundColor DarkGray
    Write-Host '~' -NoNewline -ForegroundColor Red
    Write-Host '] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'decrypting ' -NoNewline -ForegroundColor DarkGray
    $bar = @('DarkRed', 'DarkRed', 'Red', 'Red')
    for ($i = 0; $i -lt 32; $i++) {
        $c = $bar[[Math]::Min([int]($i / 8), $bar.Count - 1)]
        Write-Host '▓' -NoNewline -ForegroundColor $c
        Start-Sleep -Milliseconds 8
    }
    Write-Host ' 100%' -ForegroundColor Green
    Start-Sleep -Milliseconds 150
}

# ---------------------------------------------------------------------------
#  tool discovery
# ---------------------------------------------------------------------------
function Find-ToolFile {
    param([string]$Directory, [string[]]$Names)

    if ([string]::IsNullOrWhiteSpace($Directory)) { return $null }
    if (-not (Test-Path -LiteralPath $Directory)) { return $null }

    foreach ($n in $Names) {
        $p = Join-Path $Directory $n
        if (Test-Path -LiteralPath $p) { return (Resolve-Path -LiteralPath $p).Path }
    }
    return $null
}

function Get-BatchLauncher {
    param([string]$Directory)

    if (-not (Test-Path -LiteralPath $Directory)) { return $null }

    $f = Find-ToolFile $Directory @('start.bat', 'Start.bat', 'main.bat', 'Main.bat', 'menu.bat', 'Menu.bat')
    if ($f) { return $f }

    # some packs keep the launcher one level down (e.g. Batch-Multi-Tool\multitool\main.bat)
    $deep = Get-ChildItem -LiteralPath $Directory -Filter 'main.bat' -File -Recurse -Depth 2 -ErrorAction SilentlyContinue |
            Sort-Object { $_.FullName.Length } |
            Select-Object -First 1 -ExpandProperty FullName
    if ($deep) { return $deep }

    return (Get-ChildItem -LiteralPath $Directory -Filter '*.bat' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch 'colou?rs?\.bat$' } |
            Sort-Object Name |
            Select-Object -First 1 -ExpandProperty FullName)
}

function Get-ToolStatus {
    param([string]$File, [string]$Kind = 'bat')

    if ([string]::IsNullOrWhiteSpace($File) -or -not (Test-Path -LiteralPath $File)) {
        return @{ Text = 'MISSING'; Color = 'DarkRed' }
    }
    if ($Kind -eq 'py' -and -not (Get-PythonExe)) {
        return @{ Text = 'NO PYTHON'; Color = 'DarkYellow' }
    }
    return @{ Text = 'READY'; Color = 'Green' }
}

# ---------------------------------------------------------------------------
#  screens
# ---------------------------------------------------------------------------
function Show-StatusLine {
    $ready = 0
    foreach ($t in $script:Tools) {
        if ((Get-ToolStatus -File $t.File -Kind $t.Kind).Text -eq 'READY') { $ready++ }
    }
    $total = $script:Tools.Count
    $arsenal = @($script:Tools | Where-Object { [int]$_.Key -le 10 }).Count
    $labs = @($script:Tools | Where-Object { [int]$_.Key -gt 10 }).Count

    Write-Host '   [~] ' -NoNewline -ForegroundColor DarkGray
    Write-Host $env:USERNAME -NoNewline -ForegroundColor White
    Write-Host '@' -NoNewline -ForegroundColor DarkRed
    Write-Host 'multiofall' -NoNewline -ForegroundColor Red
    Write-Host '  |  ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'win32' -NoNewline -ForegroundColor DarkGray
    Write-Host '  |  ' -NoNewline -ForegroundColor DarkGray
    Write-Host ('{0} arsenal + {1} lab' -f $arsenal, $labs) -NoNewline -ForegroundColor DarkRed
    Write-Host '  |  ' -NoNewline -ForegroundColor DarkGray
    Write-Host ('{0}/{1}' -f $ready, $total) -NoNewline -ForegroundColor $(if ($ready -eq $total) { 'Green' } else { 'Yellow' })
    Write-Host '  |  ' -NoNewline -ForegroundColor DarkGray
    if ($script:BundledPython) {
        Write-Host 'py: bundled' -NoNewline -ForegroundColor Green
    }
    elseif (Get-PythonExe) {
        Write-Host 'py: system' -NoNewline -ForegroundColor Yellow
    }
    else {
        Write-Host 'py: none' -NoNewline -ForegroundColor Red
    }
    Write-Host '  |  ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'uid=0(root)' -NoNewline -ForegroundColor DarkRed
    Write-Host '  ' -NoNewline
    Write-Host '[ ONLINE ]' -ForegroundColor Green
}

function Write-MenuRow {
    param(
        [pscustomobject]$Tool,
        [string]$StatusText,
        [string]$StatusColor,
        [int]$InnerW = 76
    )

    $nameW   = 22
    $descW   = 28
    $statusW = 10

    $name = [string]$Tool.Name
    if ($name.Length -gt $nameW) { $name = $name.Substring(0, $nameW) }
    $desc = [string]$Tool.Desc
    if ($desc.Length -gt $descW) { $desc = $desc.Substring(0, $descW - 2) + '..' }

    Write-Host '   ║' -NoNewline -ForegroundColor DarkRed
    Write-Host '  ' -NoNewline
    Write-Host '[' -NoNewline -ForegroundColor $Tool.Accent
    Write-Host ('{0:00}' -f [int]$Tool.Key) -NoNewline -ForegroundColor White
    Write-Host ']' -NoNewline -ForegroundColor $Tool.Accent
    Write-Host '  ' -NoNewline
    Write-Host $name.PadRight($nameW) -NoNewline -ForegroundColor White
    Write-Host $desc.PadRight($descW) -NoNewline -ForegroundColor DarkGray
    Write-Host '  ' -NoNewline
    Write-Host '■ ' -NoNewline -ForegroundColor $StatusColor
    Write-Host $StatusText.PadRight($statusW) -NoNewline -ForegroundColor $StatusColor
    Write-Host '    ' -NoNewline
    Write-Host '║' -ForegroundColor DarkRed
}

function Show-Menu {
    $innerW = 76

    Write-Host ('   ╔' + ('═' * $innerW) + '╗') -ForegroundColor DarkRed

    $arsenalCount = @($script:Tools | Where-Object { [int]$_.Key -le 10 -and (Get-ToolStatus -File $_.File -Kind $_.Kind).Text -eq 'READY' }).Count
    $tail = ('{0} MODULES' -f $arsenalCount)
    $left = '[!] ARSENAL'
    $gap = $innerW - 2 - $left.Length - $tail.Length - 2

    Write-Host '   ║' -NoNewline -ForegroundColor DarkRed
    Write-Host '  ' -NoNewline
    Write-Host '[!] ' -NoNewline -ForegroundColor DarkRed
    Write-Host 'ARSENAL' -NoNewline -ForegroundColor White
    Write-Host (' ' * $gap) -NoNewline
    Write-Host $tail -NoNewline -ForegroundColor DarkGray
    Write-Host '  ' -NoNewline
    Write-Host '║' -ForegroundColor DarkRed

    Write-Host ('   ╠' + ('═' * $innerW) + '╣') -ForegroundColor DarkRed

    foreach ($t in ($script:Tools | Where-Object { [int]$_.Key -le 10 })) {
        $s = Get-ToolStatus -File $t.File -Kind $t.Kind
        Write-MenuRow -Tool $t -StatusText $s.Text -StatusColor $s.Color -InnerW $innerW
    }

    $labCount = @($script:Tools | Where-Object { [int]$_.Key -gt 10 }).Count
    $labLabel = (' SKID LAB // {0} built-in scripts ' -f $labCount)
    $line = '═' * ($innerW - 3 - $labLabel.Length)
    Write-Host '   ╠═[' -NoNewline -ForegroundColor DarkRed
    Write-Host $labLabel -NoNewline -ForegroundColor Red
    Write-Host ']' -NoNewline -ForegroundColor DarkRed
    Write-Host $line -NoNewline -ForegroundColor DarkRed
    Write-Host '╣' -ForegroundColor DarkRed

    foreach ($t in ($script:Tools | Where-Object { [int]$_.Key -gt 10 })) {
        $s = Get-ToolStatus -File $t.File -Kind $t.Kind
        Write-MenuRow -Tool $t -StatusText $s.Text -StatusColor $s.Color -InnerW $innerW
    }

    Write-Host ('   ╠' + ('═' * $innerW) + '╣') -ForegroundColor DarkRed

    $foot = @(
        @{ T = '  ';        C = 'DarkGray' },
        @{ T = '[00]';      C = 'Red'      },
        @{ T = ' EXIT';     C = 'White'    },
        @{ T = '   ';       C = 'DarkGray' },
        @{ T = '[OO]';      C = 'DarkRed'  },
        @{ T = ' FOLDER';   C = 'White'    },
        @{ T = '   ';       C = 'DarkGray' },
        @{ T = '[RR]';      C = 'Red'      },
        @{ T = ' REFRESH';  C = 'White'    },
        @{ T = '   ';       C = 'DarkGray' },
        @{ T = '[?]';       C = 'DarkYellow' },
        @{ T = ' HELP';     C = 'White'    }
    )
    $used = 0
    foreach ($p in $foot) { $used += $p.T.Length }

    Write-Host '   ║' -NoNewline -ForegroundColor DarkRed
    foreach ($p in $foot) {
        Write-Host $p.T -NoNewline -ForegroundColor $p.C
    }
    Write-Host (' ' * ($innerW - $used)) -NoNewline
    Write-Host '║' -ForegroundColor DarkRed

    Write-Host ('   ╚' + ('═' * $innerW) + '╝') -ForegroundColor DarkRed
}

function Show-Tip {
    $tips = @(
        'press R to refresh the module list.',
        'press O to open the tools folder.',
        'tools run in this window - press ENTER to come back.',
        'option 11 is the matrix. you are not ready.',
        'your ip is not a personality. option 14 proves it.',
        'ctrl+c ends any tool. so does the power button.',
        'nobody is watching. probably.',
        'opsec is a mindset. this menu is not.',
        'drop a missing tool in its folder, then press R.',
        'touch grass after three launches (optional).',
        'the mainframe is a state of mind.'
    )
    $tip = $tips[(Get-Random -Minimum 0 -Maximum $tips.Count)]

    Write-Host ''
    Write-Host '   [!] ' -NoNewline -ForegroundColor DarkRed
    Write-Host 'tip: ' -NoNewline -ForegroundColor Red
    Write-Host $tip -ForegroundColor DarkGray
}

function Show-Prompt {
    Write-Host ''
    Write-Host '   ┌─[' -NoNewline -ForegroundColor DarkRed
    Write-Host $env:USERNAME -NoNewline -ForegroundColor White
    Write-Host '@' -NoNewline -ForegroundColor DarkRed
    Write-Host 'multiofall' -NoNewline -ForegroundColor Red
    Write-Host ']─[' -NoNewline -ForegroundColor DarkRed
    Write-Host ('~/' + (Split-Path -Leaf $root)) -NoNewline -ForegroundColor White
    Write-Host ']' -ForegroundColor DarkRed
    Write-Host '   └──# ' -NoNewline -ForegroundColor Red
}

function Show-Help {
    Clear-Host
    Show-Banner

    Write-Host '   [i] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'HOW TO USE' -ForegroundColor White
    Write-Host ''
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host '1 - 10 ' -NoNewline -ForegroundColor Green
    Write-Host ' arsenal modules (redtiger, netti, soultaker, ...)' -ForegroundColor Gray
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host '11 - 17' -NoNewline -ForegroundColor Red
    Write-Host ' skid lab (matrix, hack sim, passwords, flex card, ...)' -ForegroundColor Gray
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host '00     ' -NoNewline -ForegroundColor Green
    Write-Host ' exit MultiOfAll' -ForegroundColor Gray
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'OO     ' -NoNewline -ForegroundColor Green
    Write-Host ' open the tools folder' -ForegroundColor Gray
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'RR     ' -NoNewline -ForegroundColor Green
    Write-Host ' refresh module status' -ForegroundColor Gray
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host '?      ' -NoNewline -ForegroundColor Green
    Write-Host ' this screen' -ForegroundColor Gray
    Write-Host ''
    Write-Host '   [!] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'green ■ = ready   red ■ = missing   yellow ■ = no python' -ForegroundColor DarkGray
    Write-Host '   [!] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'skid lab scripts live in extras\ and use the bundled python.' -ForegroundColor DarkGray
    Write-Host '   [!] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'everything is local. except the ip lookup. that one snitches.' -ForegroundColor DarkGray

    Wait-Return
}

function Wait-Return {
    Write-Host ''
    Write-Host '   [~] ' -NoNewline -ForegroundColor DarkRed
    Write-Host 'press ENTER to return to base ... ' -NoNewline -ForegroundColor DarkGray
    [void](Read-Host)
}

# ---------------------------------------------------------------------------
#  launcher
# ---------------------------------------------------------------------------
function Start-Tool {
    param(
        [string]$Label,
        [string]$File,
        [string]$WorkingDir,
        [ValidateSet('bat', 'py')][string]$Kind = 'bat'
    )

    Clear-Host
    Write-Host ''

    if ([string]::IsNullOrWhiteSpace($File) -or -not (Test-Path -LiteralPath $File)) {
        Write-Host '   [x] ' -NoNewline -ForegroundColor DarkRed
        Write-Host ('module offline: {0}' -f $Label) -ForegroundColor Red
        Write-Host ''
        if ($File) {
            Write-Host ('       looked for: {0}' -f $File) -ForegroundColor DarkGray
        } else {
            Write-Host ('       no launcher inside: {0}' -f $WorkingDir) -ForegroundColor DarkGray
        }
        Write-Host '       drop the tool into that folder and try again.' -ForegroundColor DarkGray
        Wait-Return
        return
    }

    if ($Kind -eq 'py' -and -not (Get-PythonExe)) {
        Write-Host '   [x] ' -NoNewline -ForegroundColor DarkRed
        Write-Host 'no python runtime available' -ForegroundColor Red
        Write-Host ''
        Write-Host '       keep runtime\python next to this file, or install Python 3.' -ForegroundColor DarkGray
        Wait-Return
        return
    }

    Write-Host '   [~] ' -NoNewline -ForegroundColor DarkGray
    Write-Host ('deploying {0} ...' -f $Label) -ForegroundColor White
    Write-Host '   [+] ' -NoNewline -ForegroundColor DarkGray
    Write-Host 'spawning child process' -ForegroundColor DarkGray
    try { [Console]::Beep(320, 45); [Console]::Beep(480, 60) } catch { }
    Start-Sleep -Milliseconds 400

    $dir = if ($WorkingDir) { $WorkingDir } else { $root }
    Push-Location -LiteralPath $dir
    try {
        if ($Kind -eq 'py') {
            $pyExe = Get-PythonExe
            & $pyExe $File
        }
        else {
            & $File
        }
    }
    finally {
        Pop-Location
        try {
            $Host.UI.RawUI.BackgroundColor = [ConsoleColor]::Black
            $Host.UI.RawUI.ForegroundColor = [ConsoleColor]::Gray
        } catch { }
    }

    Write-Host ''
    Write-Host '   [x] ' -NoNewline -ForegroundColor DarkRed
    Write-Host 'process exited' -ForegroundColor DarkGray
    Wait-Return
}

# ---------------------------------------------------------------------------
#  locate the bundled tools
# ---------------------------------------------------------------------------
$fMenuDir = Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -like '*F Menu*' } |
            Select-Object -First 1
if ($fMenuDir) { $fMenuDir = $fMenuDir.FullName } else { $fMenuDir = Join-Path $root 'F Menu' }

$batchDir   = Join-Path $root 'Batch-Multi-Tool-main'
$furnDir    = Join-Path $root 'FURN-main'
$nettiDir   = Join-Path $root 'Netti-Nuker-first'
$pentestDir = Join-Path $root 'pentesting-multitool-master'
$redDir     = Join-Path $root 'RedTiger-Tools-main'
$soulDir    = Join-Path $root 'Soultaker'

$script:Tools = @(
    [pscustomobject]@{
        Key = '1';  Name = 'F Menu';               Desc = 'phishing / token / brute';
        Accent = 'Red';     Kind = 'bat'; Dir = $fMenuDir;
        File = (Find-ToolFile $fMenuDir @('Start.bat', 'start.bat'))
    }
    [pscustomobject]@{
        Key = '2';  Name = 'Batch Multitool';      Desc = 'batch script collection';
        Accent = 'Red';        Kind = 'bat'; Dir = $batchDir;
        File = (Get-BatchLauncher $batchDir)
    }
    [pscustomobject]@{
        Key = '3';  Name = 'FURN';                 Desc = 'FurnClientBuild builder';
        Accent = 'Red';      Kind = 'py';  Dir = $furnDir;
        File = (Find-ToolFile $furnDir @('FurnClientBuild.py'))
    }
    [pscustomobject]@{
        Key = '4';  Name = 'Netti Nuker';          Desc = 'nuker suite';
        Accent = 'Red';         Kind = 'bat'; Dir = $nettiDir;
        File = (Find-ToolFile $nettiDir @('start.bat', 'Start.bat'))
    }
    [pscustomobject]@{
        Key = '5';  Name = 'Pentesting Multitool'; Desc = 'DNS / WHOIS / OSINT recon';
        Accent = 'Red';       Kind = 'bat'; Dir = $pentestDir;
        File = (Find-ToolFile $pentestDir @('start.bat', 'Start.bat'))
    }
    [pscustomobject]@{
        Key = '6';  Name = 'RedTiger';             Desc = 'multi-tool suite';
        Accent = 'Red';  Kind = 'py';  Dir = $redDir;
        File = (Find-ToolFile $redDir @('RedTiger.py'))
    }
    [pscustomobject]@{
        Key = '7';  Name = 'Soultaker';            Desc = 'multitool collection';
        Accent = 'Red'; Kind = 'bat'; Dir = $soulDir;
        File = (Find-ToolFile $soulDir @('RUNTHIS.bat'))
    }
    [pscustomobject]@{
        Key = '8';  Name = 'Azafx Multitool';      Desc = 'ping / trace / ports';
        Accent = 'Red';        Kind = 'bat'; Dir = $root;
        File = (Join-Path $root 'AzafxMultitool.bat')
    }
    [pscustomobject]@{
        Key = '9';  Name = 'HACKTOOL - TKMASTER';  Desc = 'ping / trace / geo-ip';
        Accent = 'Red';    Kind = 'bat'; Dir = $root;
        File = (Join-Path $root 'HACKTOOL - TKMASTER.bat')
    }
    [pscustomobject]@{
        Key = '10'; Name = 'SMB Bruteforce';       Desc = 'SMB password bruteforce';
        Accent = 'DarkRed';     Kind = 'bat'; Dir = $root;
        File = (Join-Path $root 'SMBbruteforce.bat')
    }
)

# --- SKID LAB : bundled extra scripts (extras\*.py) -----------------------
$extrasDir = Join-Path $root 'extras'

$script:Tools += @(
    [pscustomobject]@{
        Key = '11'; Name = 'Matrix Rain';          Desc = 'red rain / mainframe';
        Accent = 'Red';       Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('matrix_rain.py'))
    }
    [pscustomobject]@{
        Key = '12'; Name = 'Hack Simulator';       Desc = 'hollywood hacking flex';
        Accent = 'Red';         Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('hack_sim.py'))
    }
    [pscustomobject]@{
        Key = '13'; Name = 'Password Forge';       Desc = 'unbreakable passwords';
        Accent = 'Red';      Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('pass_forge.py'))
    }
    [pscustomobject]@{
        Key = '14'; Name = 'IP Recon';             Desc = 'your own ip, exposed';
        Accent = 'Red';        Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('ip_recon.py'))
    }
    [pscustomobject]@{
        Key = '15'; Name = 'ASCII Forge';          Desc = 'big text, zero talent';
        Accent = 'Red';     Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('ascii_forge.py'))
    }
    [pscustomobject]@{
        Key = '16'; Name = 'Skid Flex Card';       Desc = 'fake hacker id card';
        Accent = 'Red'; Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('flex_card.py'))
    }
    [pscustomobject]@{
        Key = '17'; Name = 'Troll Mode';           Desc = 'fake bsod prank';
        Accent = 'DarkRed';     Kind = 'py';  Dir = $extrasDir;
        File = (Find-ToolFile $extrasDir @('troll_bsod.py'))
    }
)

# ---------------------------------------------------------------------------
#  main
# ---------------------------------------------------------------------------
Set-ConsoleSize
try {
    $w = $Host.UI.RawUI.WindowSize.Width
    if ($w -ge 80) { $script:ConsoleWidth = $w }
} catch { }

Show-Boot

:main while ($true) {
    Clear-Host
    Show-Banner
    Show-StatusLine
    Show-Menu
    Show-Tip
    Show-Prompt

    $opt = Read-Host
    if ([string]::IsNullOrWhiteSpace($opt)) { break main }

    $norm = $opt.Trim().ToUpper()
    if ($norm -match '^\d{1,2}$') { $norm = [string][int]$norm }

    switch ($norm) {
        '0' { break main }
        'O' { Start-Process explorer.exe -ArgumentList $root }
        '?' { Show-Help }
        'R' { }
        default {
            $tool = $null
            if ($norm -match '^\d+$') {
                $tool = $script:Tools | Where-Object { $_.Key -eq $norm } | Select-Object -First 1
            }

            if ($tool) {
                Start-Tool -Label $tool.Name -File $tool.File -WorkingDir $tool.Dir -Kind $tool.Kind
            } else {
                Write-Host ''
                Write-Host '   [x] ' -NoNewline -ForegroundColor DarkRed
                Write-Host ('unknown option "{0}" - try again.' -f $opt) -ForegroundColor Red
                Start-Sleep -Milliseconds 900
            }
        }
    }
}

Clear-Host
Write-Host ''
Write-Host '   [x] ' -NoNewline -ForegroundColor DarkGray
Write-Host 'link severed.' -NoNewline -ForegroundColor Red
Write-Host ' stay safe out there, operator.' -ForegroundColor DarkGray
Write-Host '   [~] ' -NoNewline -ForegroundColor DarkGray
Write-Host 'logs wiped. probably.' -ForegroundColor DarkGray
Write-Host ''
Start-Sleep -Milliseconds 1200
