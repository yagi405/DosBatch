Rem ******************�������e******************
Rem 1.�w��t�H���_�����z�h���C�u�Ƃ��ă}�E���g
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************
Rem �@�w��t�H���_�p�X
set targetFolder=""
Rem �A���z�h���C�u
set drive=T:
Rem �B���O�t�@�C���p�X
set log=%0\..\FolderMounter_log.txt
Rem ********************************************

echo %DATE% %TIME%:~0,8 %0 �������J�n�� >> %log% 2>&1

if not exist %targetFolder% (
 	echo %targetFolder%�����݂��܂���B >> %log% 2>&1
 	goto ErrorHandling
)else if exist %drive% (
	echo %drive%�͂��łɎg�p����Ă��܂��B >> %log% 2>&1
	goto ErrorHandling
)

net use %drive% %targetFolder% >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

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
