::Battery Report Automation Script::
::Date Created: 6/20/24::
::Last Updated: 6/20/24::
::Version: 1.0::

@echo off

echo Laptop Battery Report Automation Script (Windows) - Version 1.0
echo.
echo Automation Script Written By: Brandon Green
echo.

:: Get the Desktop folder path and save it to a variable. ::

SETLOCAL
FOR /F "usebackq" %%f IN (`PowerShell -NoProfile -Command "Write-Host([Environment]::GetFolderPath('Desktop'))"`) DO (
  SET "DESKTOP_FOLDER=%%f"
  )

:: Generate and save the battery report to the desktop ::

powercfg /batteryreport /output "%DESKTOP_FOLDER%\battery-report.html"

echo.

:: Automatically Open the battery report ::

cd %DESKTOP_FOLDER%

"battery-report.html"

pause