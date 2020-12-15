Rem ******************�������e******************
Rem �w�肵��SQLServer�G�[�W�F���g�̃W���u�����s����
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************�ݒ���******************
Rem if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling
if "%3" == "" goto ErrorHandling
if "%4" == "" goto ErrorHandling
if "%5" == "" goto ErrorHandling

Rem �@���s�W���u��
set jobName=%~1
Rem �ASQLServer��
set serverName=%~2
Rem �BSQLServer�p�X���[�h
set passWord=%~3
Rem �CSQLServer���[�U�[ID
set userID=%~4
Rem �D�W���u���(���s����)�o�̓t�@�C���p�X
set jobInfo=%~5
Rem �E�W���u���۔���p�L�[���[�h
set successKeyWord=�W���u�͐������܂���
set failureKeyWord=�W���u�͎��s���܂���
Rem ********************************************

echo %DATE% %TIME:~0,8% %0 �������J�n��
echo %jobName%

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

echo %SQLCMD%

%SQLCMD% -Q "SELECT @@VERSION"
if errorlevel 1 ( 
	echo SQLServer�ւ̐ڑ��Ɏ��s���܂����B
	echo �T�[�o�[��,���[�U�[ID,�p�X���[�h���m�F���Ă��������B
	goto ErrorHandling
)

echo %DATE% %TIME:~0,8% %0 %jobName% ���s�J�n
%SQLCMD% -d msdb -Q"sp_start_job'%jobName%'" -b
if errorlevel 1 goto ErrorHandling

rem �W���u�̏I����60�b�҂�
timeout 60 > null

%SQLCMD% -d msdb -Q"sp_help_job @job_name ='%jobName%'" -b -s, -W -o %jobInfo%
if errorlevel 1 goto ErrorHandling
echo %DATE% %TIME:~0,8% %0 %jobName% ���s�I��

findstr %successKeyWord% %jobInfo%
if errorlevel 1 (
	findstr %failureKeyWord% %jobInfo%
	goto ErrorHandling
)

goto :ProcessEnd

:ErrorHandling
rem �ُ�I��
echo %DATE% %TIME:~0,8% %0 ���ُ�I����
exit /b 1

:ProcessEnd
rem ����I��
echo %DATE% %TIME:~0,8% %0 ������I����
exit /b 0

endlocal
