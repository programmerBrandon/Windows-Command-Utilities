:: Script Name: Windows Time Correction Tool ::
:: Author: Brandon Green ::
:: Date Created: 3/5/2025 ::
:: Date Last Modified: 3/5/2025 ::
:: Modification Reason: Script was born! ::
:: Version: 1.0 ::
:: Credit for "You are a genius beyond your time" joke goes to Nick D. ::

@echo off
echo Windows Time Correction Tool - V1.0 - Script by Brandon Green

:: Check that script is run as Administrator ::
net session >nul 2>&1
 if [%errorLevel%] == [0] (
	echo The current system time is: && time /t
	echo.
	echo The system time zone is: && tzutil /g
	echo.
	echo.
	goto stepOne
) else (
	echo.
 	echo Error: This script requires admin privileges. Please rerun the script as administrator.
	pause
	exit
)

:: Step 1 is very simple: run the basic resync command and see if it works.
:stepOne
echo Step 1: Attempt to resync the clock using resync command.
@echo on
w32tm /resync

time /t

@echo off
choice /c YN /m "Is system time still incorrect?"

if ERRORLEVEL 2 goto success :: If 'N' was typed ::

if ERRORLEVEL 1 goto stepTwo :: If 'Y' was typed ::

::End of stepOne


::Step 2 is to stop w32time service, re-register it from scratch and then restart the service.
:stepTwo
echo.
echo Step 2: Re-register and restart Windows time related services.

@echo on
net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /resync /nowait

time /t

@echo off
echo.
choice /c YN /m "Is system time still incorrect?"

if ERRORLEVEL 2 goto success :: If 'N' was typed ::

if ERRORLEVEL 1 goto stepThree :: If 'Y' was typed ::

::End Of stepTwo


::Step 3: Run command to reset the time server back to the default Microsoft Time Server.
:stepThree
echo.
echo Step 3: Set time server back to the default Microsoft Time Server.
echo.

@echo on

w32tm /config /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" /syncfromflags:manual /reliable:yes /update

time /t

@echo off
choice /c YN /m "Is system time still incorrect?"

if ERRORLEVEL 2 goto success :: If 'N' was typed ::

if ERRORLEVEL 1 goto failure :: If 'Y' was typed ::

::End of stepThree

:: Print success message and exit the script ::
:success
echo.
echo Congratulations you are a genius beyond your TIME (get it) who just saved time (literally). 
echo.
echo You may now press any key to exit (just don't ask where the "any key" is). Have a great a day! 
pause
exit

::End of success.


:: Print failure message, some additional troubleshooting steps and exit the script ::
:failure
echo.
echo If the time is still incorrect, you will need to continue troubleshooting manually. Here are some things to try:
echo * Verify the time zone is correct.
echo * Set the time manually in Windows settings.
echo * Reseat and/or replace CMOS battery (if not troubleshooting remotely).
echo * Have you tried turning it off and back on again? (Sorry couldn't resist the joke).
echo.
echo Press any key to exit (just don't ask where the "any key" is). Have a great a day!
pause
exit

::End of failure.