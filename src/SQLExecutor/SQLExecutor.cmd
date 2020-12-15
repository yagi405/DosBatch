Rem ******************�������e******************
Rem �w�肵���t�H���_�Ɋi�[����Ă���SQL�t�@�C����S�Ď��s���A���ʂ��e�L�X�g�t�@�C���ɏo�͂���B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************�ݒ���******************
if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling
if "%3" == "" goto ErrorHandling
if "%4" == "" goto ErrorHandling
if "%5" == "" goto ErrorHandling

Rem �@���s�Ώ�SQL�t�@�C���i�[��t�H���_
Rem ���p�����[�^(%1)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%1"=="" (
	set sqlFolder=%~1
) else (
	Rem set sqlFolder=%0\..\SQL
)

Rem �ASQLServer��
Rem ���p�����[�^(%2)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%2"=="" (
	set serverName=%~2
) else (
	Rem set serverName=DAMSV14
)

Rem �BSQLServer�p�X���[�h
Rem ���p�����[�^(%3)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%3"=="" (
	set passWord=%~3
) else (
	Rem set passWord=YoSkqXadj9
)

Rem �CSQLServer���[�U�[ID
Rem ���p�����[�^(%4)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%4"=="" (
	set userID=%~4
) else (
	Rem set userID=sa
)

Rem �D���s���ʊi�[��t�H���_
Rem ���p�����[�^(%5)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%5"=="" (
	set resultFolder=%~5
) else (
	Rem set resultFolder=%0\..\SQL_Result
)

Rem ********************************************

echo %DATE% %TIME:~0,8% %0 �������J�n��

if not exist %resultFolder% (mkdir %resultFolder%)

if not exist %sqlFolder% (
	echo %sqlFolder%�����݂��܂���B
	goto ErrorHandling
)

echo ================���s�Ώۃt�@�C��================
dir %sqlFolder%\*.sql /b
echo ================================================
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION"
if errorlevel 1 ( 
	echo SQLServer�ւ̐ڑ��Ɏ��s���܂����B
	echo �T�[�o�[��,���[�U�[ID,�p�X���[�h���m�F���Ă��������B
	goto ErrorHandling
)

for /F "delims=." %%a in ('dir %sqlFolder%\*.sql /b') do (
	echo %DATE% %TIME:~0,8% %0 %sqlFolder%\%%a.sql ���s�J�n
	%SQLCMD% -i %sqlFolder%\%%a.sql -b -W -o %resultFolder%\%%a.txt
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %sqlFolder%\%%a.sql ���s�I��
)

goto ProcessEnd

:ErrorHandling
rem �ُ�I��
echo %DATE% %TIME:~0,8% %0 ���ُ�I����
exit /b 1

:ProcessEnd
rem ����I��
echo %DATE% %TIME:~0,8% %0 ������I����
exit /b 0

endlocal
