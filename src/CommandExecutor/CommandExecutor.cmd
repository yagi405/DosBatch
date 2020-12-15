@echo off

call :Initialsetting
for %%l in (%LAVEL_NAMES%) do if "%1"=="%%l" call :%* & exit /b
call :ErrorHandling Initialsetting - ArgumentException: %*
exit /b

Rem **********************************************************************************

:Initialsetting
set LAVEL_NAMES=Method,Command
goto :EOF

Rem **********************************************************************************

:ErrorHandling
Echo %~nx0 - %* 
Pause
goto :EOF

Rem **********************************************************************************

:Method
call %LOGGER% DEBUG Method Begin
call %LOGGER% INFO Method call %*
call %*
set MYERRORLEVEL=%ERRORLEVEL%
call %LOGGER% DEBUG ERRORLEVEL=%MYERRORLEVEL%
call %LOGGER% DEBUG Method END

goto :EOF

:Command
call %LOGGER% DEBUG Command Begin
call %LOGGER% INFO Command %*
%* >> %LOG_FILE% 2>&1
set MYERRORLEVEL=%ERRORLEVEL%
call %LOGGER% DEBUG ERRORLEVEL=%MYERRORLEVEL%
call %LOGGER% DEBUG Command END

goto :EOF