@echo off

:: Script Name: Windows Corruption Scanner And Repair Tool ::
:: Author: Brandon Green ::
:: Date Created: 7/9/2023 ::
:: Date Last Modified: 7/9/2023 ::
:: Version: 1.0 ::

::This script uses sfc/ scannow command to check for corruption, when this is finished user is
::prompted to type 'Y' or 'N' as to whether corruption was found, if Y, runs DISM to fix issues. ::

echo Windows Corruption Scanner And Repair Tool - Version 1.0
echo.
echo Running 'sfc /scannow' to check for corruption.

:: SFC SCAN COMMAND ::
sfc /scannow

::Prompts the user to Y or N, if issues were found they should type Y, otherwise type N.
::If user types Y, caseOne commands will be run. Otherwise caseTwo will be run.
choice /c YN /m "Were integrity issues found?"

if ERRORLEVEL 2 goto caseTwo :: If 'N' was typed ::

if ERRORLEVEL 1 goto caseOne :: If 'Y' was typed ::

:: CASE ONE NOTES ::
:: If issues were found, runs Deployment Image Servicing and Management tool (DISM) to fix them. ::
:: It will also run sfc /scannow a 2nd time after completing the scan to verify issues are gone. ::
:: END CASE ONE NOTES :: 

:caseOne
 echo. 
 echo Running 'DISM /Online /Cleanup-Image /RestoreHealth' to fix corruption issues.

 :: DISM COMMAND ::
 DISM /Online /Cleanup-Image /RestoreHealth

 echo.
 echo Now running 'SFC /scannow' again to verify that corruption is gone. 
  
 :: SFC SCAN COMMAND ::
 sfc /scannow

 echo.
 echo If no further integrity issues were found, please restart the computer when ready to finish the changes.
 echo Press any key to close this window and exit the program!
 pause
 goto END

:: CASE TWO NOTES:: 
:: If no were issues were found, user is given brief instructions to press any key, which will ::
:: exit the program through the ':END' block. ::
:: END CASE TWO NOTES! ::

:caseTwo
 echo.
 echo If no issues were found, then no further action is required and you may press any key to close this window.
 echo.
 pause
 goto END

:: END CODE BLOCK NOTES ::
::When program is done with everything, this block can be used to exit program.
:: END OF 'END' CODE BLOCK NOTES ::

:END
  exit