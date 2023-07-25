@echo off

:: Script Name: Hidden Admin Account Tool (Windows) ::
:: Author: Brandon Green ::
:: Date Created: 7/24/2023 ::
:: Date Last Modified: 7/24/2023 ::
:: Version: 1.0 ::

echo Hidden Admin Account Tool (Windows) - Version 1.0 - Author: Brandon Green
echo.

net session >nul 2>&1
 if [%errorLevel%] == [0] (
 	choice /c 12 /m "Type 1 to activate the hidden administrator account, or 2 to deactivate it."
 ) else (
 	echo Error: This script requires admin priviledges. Please rerun the script as administrator.
	pause
	exit
 )

:: If '2' was typed ::
if ERRORLEVEL == 2 (
	goto :caseTwo
)

:: If '1' was typed ::
if ERRORLEVEL == 1 (
	goto caseOne
)


:caseOne
echo.
net user administrator /active:yes
echo Hidden Administrator account has been activated!
pause
goto END

:caseTwo 
echo.
net user administrator /active:no
echo Hidden Administrator account has been deactivated!
pause
goto END

:END
exit



