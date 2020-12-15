Rem ******************�������e******************
Rem �w�肵���t�H���_�Ɋi�[����Ă���dat�t�@�C����S��BCP�Ŏ�荞�ށB
Rem dat�t�@�C����(�g���q����)���C���|�[�g��e�[�u���ƂȂ�B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@�����Ώ�dat�t�@�C���i�[�t�H���_
set bcpFolder=%0\..\BCP

Rem �ASQLServer��
set serverName=

Rem �BDB��
set dbName=

Rem �CSQLServer�p�X���[�h
set passWord=

Rem �DSQLServer���[�U�[ID
set userID=

Rem �E���O�t�@�C���p�X
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

echo ================�����Ώۃt�@�C��================ >> %log% 2>&1
dir %bcpFolder%\*.dat /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION" >> %log% 2>&1
if errorlevel 1 ( 
	echo SQLServer�ւ̐ڑ��Ɏ��s���܂����B >> %log% 2>&1
	echo �T�[�o�[��,���[�U�[ID,�p�X���[�h���m�F���Ă��������B >> %log% 2>&1
	goto ErrorHandling
)

for /f "delims=." %%a in ('dir %bcpFolder%\*.dat /b') do (
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.dat �C���|�[�g�J�n >> %log% 2>&1
	BCP %dbName%%%a in %bcpFolder%\%%a.dat -n -E -S %serverName% -U %userID% -P %passWord% >> %log% 2>&1
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.dat �C���|�[�g�I�� >> %log% 2>&1
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
