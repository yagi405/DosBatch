Rem ******************�������e******************
Rem �w��t�@�C�����w��f�B���N�g���փR�s�[����B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************�ݒ���******************
if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling

Rem �@�R�s�[���t�@�C���p�X
set srcFilePath=%~1
Rem �A�R�s�[��f�B���N�g��
set tempFolder=%~2
Rem �B�R�s�[��̃t�@�C����
for /f %%F in ('echo %srcFilePath%') do set destFileName=%%~nxF
Rem ********************************************

echo %DATE% %TIME:~0,8% %0 �������J�n��

if not exist %srcFilePath% (
	echo %srcFilePath%�����݂��܂���B
	goto ErrorHandling
)

if not exist %tempFolder% (mkdir %tempFolder%)
if errorlevel 1 goto ErrorHandling

echo =============�������e=============
echo �R�s-��:%srcFilePath%
echo �R�s-��:%tempFolder%\%destFileName%
echo ==================================

Rem �������ŏ㏑������
copy /y %srcFilePath% %tempFolder%\%destFileName%
if errorlevel 1 goto ErrorHandling

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
