Rem ******************処理内容******************
Rem 指定したフォルダに格納されているzipファイルを全てカレントディレクトリ上に展開する。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①解凍対象zipファイル格納先フォルダ
Rem ★パラメータ(%1)が存在した場合にはパラメータを優先する。
if not "%1"=="" (
	set zipFolder=%~1
) else (
	set zipFolder=%0\..\Zip
)

Rem ②ログファイルパス
set logFolder=%0\..\Log
set log=%logFolder%\%DATE:/=%_UnZip_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼ >> %log% 2>&1

if not exist %zipFolder% (
	echo %zipFolder%が存在しません。 >> %log% 2>&1
	goto ErrorHandling
)

if not exist %0\..\7za.exe (
	echo %0\..\7za.exeが存在しません。 >> %log% 2>&1
	goto ErrorHandling
)

for /F %%a in ('dir %zipFolder%\*.zip /b') do (
	echo %DATE% %TIME:~0,8% %0 %zipFolder%\%%a.zip 解凍開始 >> %log% 2>&1
	%0\..\7za.exe x %zipFolder%\%%a
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %zipFolder%\%%a.zip 解凍終了 >> %log% 2>&1
) 

goto ProcessEnd

:ErrorHandling
rem 異常終了
echo %DATE% %TIME:~0,8% %0 ■異常終了■ >> %log% 2>&1
echo エラーが発生したため、処理を中止しました。
echo エラー内容はログファイルを確認してください。
pause
exit /b 1

:ProcessEnd
rem 正常終了
echo %DATE% %TIME:~0,8% %0 ■正常終了■ >> %log% 2>&1
echo 処理が完了しました。
pause
exit /b 0

endlocal