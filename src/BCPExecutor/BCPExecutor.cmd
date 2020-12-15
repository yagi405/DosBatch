Rem ******************�������e******************
Rem �w�肵���t�H���_�Ɋi�[����Ă���SQL��S��BCP�R�}���h�Ƃ��Ď��s���Adat�t�@�C���ɏo�͂���B
Rem SQL�̓e�L�X�g�t�@�C���̐擪�s�ɋL�ڂ���B(��s�ŋL�ڂ��邱��)
Rem �e�L�X�g�t�@�C������dat�t�@�C�����ƂȂ�B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@���s�Ώۃe�L�X�g�t�@�C���i�[�t�H���_
Rem ���p�����[�^(%1)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%1"=="" (
	set bcpFolder=%~1
) else (
	set bcpFolder=%0\..\BCP
)

Rem �ASQLServer��
Rem ���p�����[�^(%2)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%2"=="" (
	set serverName=%~2
) else (
	set serverName=
)

Rem �BSQLServer�p�X���[�h
Rem ���p�����[�^(%3)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%3"=="" (
	set passWord=%~3
) else (
	set passWord=
)

Rem �CSQLServer���[�U�[ID
Rem ���p�����[�^(%4)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%4"=="" (
	set userID=%~4
) else (
	set userID=
)

Rem �D���O�t�@�C���p�X
set logFolder=%0\..\Log
set log=%logFolder%\%DATE:/=%_BCPExecutor_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 �������J�n�� >> %log% 2>&1

if not exist %bcpFolder% (
	echo %bcpFolder%�����݂��܂���B >> %log% 2>&1
	goto ErrorHandling
)

echo ================���s�Ώۃt�@�C��================ >> %log% 2>&1
dir %bcpFolder%\*.txt /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION" >> %log% 2>&1
if errorlevel 1 ( 
	echo SQLServer�ւ̐ڑ��Ɏ��s���܂����B >> %log% 2>&1
	echo �T�[�o�[��,���[�U�[ID,�p�X���[�h���m�F���Ă��������B >> %log% 2>&1
	goto ErrorHandling
)

for /f "delims=." %%a in ('dir %bcpFolder%\*.txt /b') do (

	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.txt ���s�J�n >> %log% 2>&1
	for %%F in (%bcpFolder%\%%a.txt) do (
		set /p B=<"%%~F"
		BCP !B! queryout %bcpFolder%\%%a.dat -n -S %serverName% -U %userID% -P %passWord% >> %log% 2>&1
		if errorlevel 1 goto ErrorHandling
	)
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.txt ���s�I�� >> %log% 2>&1
)

goto ProcessEnd

:ErrorHandling
rem �ُ�I��
echo %DATE% %TIME:~0,8% %0 ���ُ�I���� >> %log% 2>&1
echo �G���[�������������߁A�����𒆎~���܂����B
echo �G���[���e�̓��O�t�@�C�����m�F���Ă��������B
pause
exit /b 1

:ProcessEnd
rem ����I��
echo %DATE% %TIME:~0,8% %0 ������I���� >> %log% 2>&1
echo �������������܂����B
pause
exit /b 0

endlocal
