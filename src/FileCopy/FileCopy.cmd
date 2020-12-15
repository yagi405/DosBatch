Rem ******************処理内容******************
Rem 指定ファイルを指定ディレクトリへコピーする。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************設定情報******************
if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling

Rem ①コピー元ファイルパス
set srcFilePath=%~1
Rem ②コピー先ディレクトリ
set tempFolder=%~2
Rem ③コピー後のファイル名
for /f %%F in ('echo %srcFilePath%') do set destFileName=%%~nxF
Rem ********************************************

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼

if not exist %srcFilePath% (
	echo %srcFilePath%が存在しません。
	goto ErrorHandling
)

if not exist %tempFolder% (mkdir %tempFolder%)
if errorlevel 1 goto ErrorHandling

echo =============処理内容=============
echo コピ-元:%srcFilePath%
echo コピ-先:%tempFolder%\%destFileName%
echo ==================================

Rem 無条件で上書きする
copy /y %srcFilePath% %tempFolder%\%destFileName%
if errorlevel 1 goto ErrorHandling

goto :ProcessEnd

:ErrorHandling
rem 異常終了
echo %DATE% %TIME:~0,8% %0 ■異常終了■
exit /b 1

:ProcessEnd
rem 正常終了
echo %DATE% %TIME:~0,8% %0 ■正常終了■
exit /b 0

endlocal
