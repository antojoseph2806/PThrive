@echo off
echo Adding Windows Firewall rule for PThrive Backend...
echo.
netsh advfirewall firewall add rule name="PThrive Backend Port 3000" dir=in action=allow protocol=TCP localport=3000
echo.
echo Done! Press any key to exit...
pause
