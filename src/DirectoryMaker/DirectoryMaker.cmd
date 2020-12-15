Rem ******************�������e******************
Rem �w��t�@�C���ɋL�ڂ���Ă���f�B���N�g�����A�S�s���쐬����B(���݂��Ȃ��ꍇ�̂�)
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@�쐬�Ώۃf�B���N�g���L�ڃe���v���[�g
Rem ���p�����[�^(%1)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
if not "%1"=="" (
	set directoryTemplate=%~1
) else (
	set directoryTemplate=%~0\..\DirectoryTemplate.txt
)

Rem �A���O�t�@�C���p�X
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_DirectoryMaker_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 �������J�n��

if not exist %directoryTemplate% (
	echo %directoryTemplate%�����݂��܂���B
	goto ErrorHandling
)

for /f "delims=" %%a in (%directoryTemplate%) do (
	echo %DATE% %TIME:~0,8% %0 %%a �쐬�J�n
	if not exist %%a (
		mkdir %%a
		if errorlevel 1 goto ErrorHandling
	) else (
		echo %%a�͊��ɑ��݂��Ă��邽�߁A�������X�L�b�v���܂��B
	)
	echo %DATE% %TIME:~0,8% %0 %%a �쐬����
)
goto ProcessEnd

:ErrorHandling
rem �ُ�I��
echo %DATE% %TIME:~0,8% %0 ���ُ�I����
echo;
echo;
echo �G���[�������������߁A�����𒆎~���܂����B
echo �G���[���e�̓��O�t�@�C�����m�F���Ă��������B
pause
exit /b 1

:ProcessEnd
rem ����I��
echo %DATE% %TIME:~0,8% %0 ������I����
echo;
echo;
echo �������������܂����B
pause
exit /b 0

endlocal
