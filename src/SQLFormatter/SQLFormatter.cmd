Rem ******************�������e******************
Rem �w�肵���t�H���_�Ɋi�[����Ă���SQL�t�@�C����S�Ĉȉ��̃��[���ɏ]�����`����B
Rem �@2�s�ڂɁu:Error stdout�v��}��
Rem �A�uGo�v���폜
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************�ݒ���******************

Rem �@�����Ώ�SQL�t�@�C���i�[��t�H���_
set sqlFolder=%0\..\SQL

Rem �A�s�}���p�e���v���[�g�t�@�C���p�X
set insertFile=%~0\..\InsertTemplate.txt

Rem �B���s���ʊi�[��t�H���_
set resultFolder=%~0\..\SQL_Result

Rem �C���O�t�@�C���p�X
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_SQLFormatter_log.txt

Rem �D�������ݗp�ꎞ�t�@�C��
Rem �������t�@�C���Ɠ����ɂ��Ȃ��悤����
set tempFile=%0\..\tmp.sql

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 �������J�n�� >> %log% 2>&1

chcp 932 >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

if not exist %resultFolder% (mkdir %resultFolder% >> %log% 2>&1)
if errorlevel 1 goto ErrorHandling

if not exist %sqlFolder% (
	echo %sqlFolder%�����݂��܂���B >> %log% 2>&1
	goto ErrorHandling
)

echo ================���s�Ώۃt�@�C��================ >> %log% 2>&1
dir %sqlFolder%\*.sql /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

for /f %%a in ('dir %sqlFolder%\*.sql /b') do call :Writer %%a >> %log% 2>&1

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

:Writer
echo =============================================================
echo %~1
if errorlevel 1 goto ErrorHandling
echo =============================================================
set rowNum=1

for /f "tokens=1* delims=: eol=" %%b in ('findstr /n "^" %sqlFolder%\%~1') do (
if "!rowNum!"=="2" type !insertFile! >> !tempFile!
if errorlevel 1 goto ErrorHandling
echo. %%c >> !tempFile!
if errorlevel 1 goto ErrorHandling
set /a rowNum=!rowNum! + 1
)
type %tempFile% > %resultFolder%\%~1
if errorlevel 1 goto ErrorHandling
del %tempFile%

endlocal
