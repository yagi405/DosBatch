Rem ******************�������e******************
Rem �w�肵���t�H���_�Ɋi�[����Ă���zip�t�@�C����S�ăJ�����g�f�B���N�g����ɓW�J����B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@�𓀑Ώ�zip�t�@�C���i�[��t�H���_
Rem ���p�����[�^(%1)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%1"=="" (
	set zipFolder=%~1
) else (
	set zipFolder=%0\..\Zip
)

Rem �A���O�t�@�C���p�X
set logFolder=%0\..\Log
set log=%logFolder%\%DATE:/=%_UnZip_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 �������J�n�� >> %log% 2>&1

if not exist %zipFolder% (
	echo %zipFolder%�����݂��܂���B >> %log% 2>&1
	goto ErrorHandling
)

if not exist %0\..\7za.exe (
	echo %0\..\7za.exe�����݂��܂���B >> %log% 2>&1
	goto ErrorHandling
)

for /F %%a in ('dir %zipFolder%\*.zip /b') do (
	echo %DATE% %TIME:~0,8% %0 %zipFolder%\%%a.zip �𓀊J�n >> %log% 2>&1
	%0\..\7za.exe x %zipFolder%\%%a
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %zipFolder%\%%a.zip �𓀏I�� >> %log% 2>&1
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