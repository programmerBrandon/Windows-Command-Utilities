@echo off

:: Script Name: Windows Update Troubleshooting Utility ::
:: Script By: Brandon Green ::
:: Date Created: 8/28/2023 ::
:: Date Last Modified: 8/28/2023 ::
:: Version: 1.0 ::

echo Windows Update Repair Utility - Version 1.0 - Author: Brandon Green
echo.

:: Check that script is run as Administrator ::
net session >nul 2>&1
 if [%errorLevel%] == [0] (
 	goto step1
 ) else (
 	echo Error: This script requires admin privileges. Please rerun the script as administrator.
	pause
	exit
 )


::Step 1: Run Windows Update Troubleshooter
:step1

echo Step 1: Run Windows Update Troubleshooter
echo.

choice /c YN /m "Did you already run the Windows Update Troubleshooter?"
if [%errorLevel%] == [1] (
	echo.
	echo Skipping Windows Update Troubleshooter and proceeding to step 2!
	echo.
	goto step2
)

@echo on

msdt.exe /id WindowsUpdateDiagnostic

@echo off
goto step2
:: END OF STEP 1 ::

:: Step 2: Restart Windows Update Related Services ::
:step2 

echo.
echo Step 2: Restart Windows Update Related Services
echo.

choice /c YN /m "Did you already restart Windows Update Related Services?"
if [%errorLevel%] == [1] (
	echo.
	echo Skipping restart of services and proceeding to step 3!
	echo.
	goto step3
)

::pause

::Stop The Windows Update Related Services
@echo on
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc

::Restart Windows Update Related Services
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

@echo Windows Update Related Services Restarted!
@echo off

goto step3

::END OF STEP 2::

::Step 3: Run sfc/scannow and DISM ::
:step3

choice /c YN /m "Did you run sfc/scannow and DISM?"
if [%errorLevel%] == [1] (
	echo.
	echo sfc and dism and proceeding to final step!
	goto step4
)

echo.
echo Step 3: Run sfc/scannow and DISM
echo.

@echo on

sfc/scannow
DISM /Online /Cleanup-Image /RestoreHealth

@echo off
goto step4

:: END OF STEP 3 ::

:step4 :: Step 4: Restart pc and give further instructions to user ::
echo.
echo FINAL STEP
echo.
echo The final step is to restart the computer and check if updates are able to complete normally again. If they do not, you can try the following steps: 
echo. 
echo 1. Try downloading the update manually from the Windows Update Catalog (https://www.catalog.update.microsoft.com/Home.aspx) and searching by the update kb number.
echo.
echo 2. Try using a restore point to restore the computer back to a state prior to when the update issues occurred.
echo. 
echo 3. Try performing a System Refresh/Upgrade In Place using a Windows installation flash drive, make sure to select the option to 'Keep apps and files', otherwise all programs and files will be deleted.
echo.
echo 4. If all of the above steps do not solve the issue, then you might to resort to the nuclear option of performing a fresh install of Windows, this will result in all files and programs being lost, so make sure to do a full backup of any files and data you may need before performing this step.
echo.

choice /c YN /m "Did want to restart the computer now?"
if [%errorLevel%] == [1] (
	echo.
	shutdown -r
) else (
	echo Press any key to exit!
	pause
	goto END
)

:: END OF STEP 4 ::

:END
exit

