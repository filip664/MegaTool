@echo off
color 04
chcp 65001 >nul
:banner
echo.                          ██░ ██  ▄▄▄       ▄████▄   ██ ▄█▀▄▄▄█████▓ ▒█████   ▒█████   ██▓       
echo.                         ▓██░ ██▒▒████▄    ▒██▀ ▀█   ██▄█▒ ▓  ██▒ ▓▒▒██▒  ██▒▒██▒  ██▒▓██▒       
echo.                         ▒██▀▀██░▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ ▒ ▓██░ ▒░▒██░  ██▒▒██░  ██▒▒██░       
echo.                         ░▓█ ░██ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ ░ ▓██▓ ░ ▒██   ██░▒██   ██░▒██░       
echo.                         ░▓█▒░██▓ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄  ▒██▒ ░ ░ ████▓▒░░ ████▓▒░░██████▒   
echo.                          ▒ ░░▒░▒ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒  ▒ ░░   ░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░▓  ░   
echo.                          ▒ ░▒░ ░  ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░    ░      ░ ▒ ▒░   ░ ▒ ▒░ ░ ░ ▒  ░   
echo.                          ░  ░░ ░  ░   ▒   ░        ░ ░░ ░   ░      ░ ░ ░ ▒  ░ ░ ░ ▒    ░ ░      
echo.                          ░  ░  ░      ░  ░░ ░      ░  ░                ░ ░      ░ ░      ░  ░   
echo.                                        ░                                                   
echo.                                              FROM !!!!TKMASTER!!!!      
echo.
echo.
echo.                                       $-------------------------------------$                          
echo.                                       $ 1)IP Tracer          4)IP Flood     $                                
echo.                                       $                                     $              
echo.                                       $ 2)IP Pinger          5)IP Shutdown  $   
echo.                                       $                                     $                                                                            
echo.                                       $ 3)IP Config          6)IP Geolocate $                                               
echo.                                       $-------------------------------------$    00 - EXIT 
echo.                                       BLUE = SAFE TO USE  YELLOW = RISKY 
echo.
set /p option="------------------> "

if /i "%option%" EQU "1" goto tracer
if /i "%option%" EQU "2" goto ping
if /i "%option%" EQU "3" goto ipconfig
if /i "%option%" EQU "4" goto flood
if /i "%option%" EQU "5" goto shutdown
if /i "%option%" EQU "6" goto geolocate
if /i "%option%" EQU "00" goto exit

:tracer
cls
color 3
set /p ip1="Enter IP To Trace: "
tracert %ip1%
echo Press Any Key To Continue...
pause >nul
cls
color 04
goto banner

:ping
cls
color 3
set /p ip2="Enter IP To Ping: "
ping %ip2%
echo Press Any Key To Continue...
pause >nul
cls
color 04
goto banner

:ipconfig
cls
color 3
ipconfig/all
echo Press Any Key To Continue...
pause >nul
cls
color 04
goto banner 

:flood 
cls
color 3
set /p ip3="Enter IP You Wanna Flood: "
ping %ip3% -t
echo Press Any Key To Continue...
pause >nul
cls
color 04
goto banner

:shutdown
cls
color 6
echo Press Any Key To Open Menu...
pause >nul
shutdown -i
echo Press Any Key To Continue...
pause >nul
cls
color 04
goto banner 

:geolocate
cls
color 3
set /p ip4="Enter IP To GeoLocate: "
curl https://ipinfo.io/%ip4%/json
echo Press Any Key To Continue...
pause >nul 
cls
color 04
goto banner

:exit
cls
color 5
echo GOODBYE...
timeout /t 2 >nul
exit