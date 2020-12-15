Rem ******************処理内容******************
Rem 指定ファイルに記載されているディレクトリを、全行分作成する。(存在しない場合のみ)
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①作成対象ディレクトリ記載テンプレート
Rem ★パラメータ(%1)が存在した場合にはパラメータを優先する。
if not "%1"=="" (
	set directoryTemplate=%~1
) else (
	set directoryTemplate=%~0\..\DirectoryTemplate.txt
)

Rem ②ログファイルパス
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_DirectoryMaker_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼

if not exist %directoryTemplate% (
	echo %directoryTemplate%が存在しません。
	goto ErrorHandling
)

for /f "delims=" %%a in (%directoryTemplate%) do (
	echo %DATE% %TIME:~0,8% %0 %%a 作成開始
	if not exist %%a (
		mkdir %%a
		if errorlevel 1 goto ErrorHandling
	) else (
		echo %%aは既に存在しているため、処理をスキップします。
	)
	echo %DATE% %TIME:~0,8% %0 %%a 作成完了
)
goto ProcessEnd

:ErrorHandling
rem 異常終了
echo %DATE% %TIME:~0,8% %0 ■異常終了■
echo;
echo;
echo エラーが発生したため、処理を中止しました。
echo エラー内容はログファイルを確認してください。
pause
exit /b 1

:ProcessEnd
rem 正常終了
echo %DATE% %TIME:~0,8% %0 ■正常終了■
echo;
echo;
echo 処理が完了しました。
pause
exit /b 0

endlocal
