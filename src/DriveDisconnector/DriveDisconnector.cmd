Rem ******************�������e******************
Rem �w�肵���l�b�g���[�N�h���C�u��ؒf����B
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@�w��h���C�u
Rem ���p�����[�^(%1)�����݂����ꍇ�ɂ̓p�����[�^��D�悷��B
Rem ���p�����[�^�͕����ݒ�\(�������̏ꍇ�̓J���}��؂�)
if "%1"=="" (
	set drive=T:
) else (
	set drive=Nothing
)

Rem �A���O�t�@�C���p�X
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_DriveDisconnector_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME%:~0,8 %0 �������J�n�� >> %log% 2>&1

if %drive%==Nothing (

	for %%d in (%*) do (
		if not exist %%d (
			echo %%d�͑��݂��܂���B >> %log% 2>&1
			goto ErrorHandling
		) else ( 
			echo ================%%d�ؒf�����J�n================ >> %log% 2>&1
			net use %%d /delete /YES >> %log% 2>&1
			net use /PERSISTENT:NO >> %log% 2>&1
			if not !ERRORLEVEL!==0 goto ErrorHandling
			echo ================%%d�ؒf��������================ >> %log% 2>&1
		)
	)
	
) else (

	for %%a in (%drive%) do (
		if not exist %%a (
			echo %%a�͑��݂��܂���B >> %log% 2>&1
			goto ErrorHandling
		) else ( 
			echo ================%%a�ؒf�����J�n================ >> %log% 2>&1
			net use %%a /delete /YES >> %log% 2>&1
			net use /PERSISTENT:NO >> %log% 2>&1
			if not !ERRORLEVEL!==0 goto ErrorHandling
			echo ================%%a�ؒf��������================ >> %log% 2>&1
		)
	)	
)
goto ProcessEnd

:ErrorHandling
rem �ُ�I��
echo %DATE% %TIME%:~0,8 %0 ���ُ�I���� >> %log% 2>&1
echo �G���[�������������߁A�����𒆎~���܂����B
echo �G���[���e�̓��O�t�@�C�����m�F���Ă��������B
pause
exit /b 1

:ProcessEnd
rem ����I��
echo %DATE% %TIME%:~0,8 %0 ������I���� >> %log% 2>&1
echo ����������ɏI�����܂����B
pause
exit /b 0

endlocal
