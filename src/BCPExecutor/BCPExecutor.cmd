Rem ******************処理内容******************
Rem 指定したフォルダに格納されているSQLを全てBCPコマンドとして実行し、datファイルに出力する。
Rem SQLはテキストファイルの先頭行に記載する。(一行で記載すること)
Rem テキストファイル名がdatファイル名となる。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①実行対象テキストファイル格納フォルダ
Rem ★パラメータ(%1)が存在した場合にはパラメータを優先する。
if not "%1"=="" (
	set bcpFolder=%~1
) else (
	set bcpFolder=%0\..\BCP
)

Rem ②SQLServer名
Rem ★パラメータ(%2)が存在した場合にはパラメータを優先する。
if not "%2"=="" (
	set serverName=%~2
) else (
	set serverName=
)

Rem ③SQLServerパスワード
Rem ★パラメータ(%3)が存在した場合にはパラメータを優先する。
if not "%3"=="" (
	set passWord=%~3
) else (
	set passWord=
)

Rem ④SQLServerユーザーID
Rem ★パラメータ(%4)が存在した場合にはパラメータを優先する。
if not "%4"=="" (
	set userID=%~4
) else (
	set userID=
)

Rem ⑤ログファイルパス
set logFolder=%0\..\Log
set log=%logFolder%\%DATE:/=%_BCPExecutor_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼ >> %log% 2>&1

if not exist %bcpFolder% (
	echo %bcpFolder%が存在しません。 >> %log% 2>&1
	goto ErrorHandling
)

echo ================実行対象ファイル================ >> %log% 2>&1
dir %bcpFolder%\*.txt /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION" >> %log% 2>&1
if errorlevel 1 ( 
	echo SQLServerへの接続に失敗しました。 >> %log% 2>&1
	echo サーバー名,ユーザーID,パスワードを確認してください。 >> %log% 2>&1
	goto ErrorHandling
)

for /f "delims=." %%a in ('dir %bcpFolder%\*.txt /b') do (

	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.txt 実行開始 >> %log% 2>&1
	for %%F in (%bcpFolder%\%%a.txt) do (
		set /p B=<"%%~F"
		BCP !B! queryout %bcpFolder%\%%a.dat -n -S %serverName% -U %userID% -P %passWord% >> %log% 2>&1
		if errorlevel 1 goto ErrorHandling
	)
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.txt 実行終了 >> %log% 2>&1
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
