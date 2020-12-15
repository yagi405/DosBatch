Rem ******************処理内容******************
Rem 指定したフォルダに格納されているSQLファイルを全て実行し、結果をテキストファイルに出力する。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************設定情報******************
if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling
if "%3" == "" goto ErrorHandling
if "%4" == "" goto ErrorHandling
if "%5" == "" goto ErrorHandling

Rem ①実行対象SQLファイル格納先フォルダ
Rem ★パラメータ(%1)が存在した場合にはパラメータを優先する。
if not "%1"=="" (
	set sqlFolder=%~1
) else (
	Rem set sqlFolder=%0\..\SQL
)

Rem ②SQLServer名
Rem ★パラメータ(%2)が存在した場合にはパラメータを優先する。
if not "%2"=="" (
	set serverName=%~2
) else (
	Rem set serverName=DAMSV14
)

Rem ③SQLServerパスワード
Rem ★パラメータ(%3)が存在した場合にはパラメータを優先する。
if not "%3"=="" (
	set passWord=%~3
) else (
	Rem set passWord=YoSkqXadj9
)

Rem ④SQLServerユーザーID
Rem ★パラメータ(%4)が存在した場合にはパラメータを優先する。
if not "%4"=="" (
	set userID=%~4
) else (
	Rem set userID=sa
)

Rem ⑤実行結果格納先フォルダ
Rem ★パラメータ(%5)が存在した場合にはパラメータを優先する。
if not "%5"=="" (
	set resultFolder=%~5
) else (
	Rem set resultFolder=%0\..\SQL_Result
)

Rem ********************************************

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼

if not exist %resultFolder% (mkdir %resultFolder%)

if not exist %sqlFolder% (
	echo %sqlFolder%が存在しません。
	goto ErrorHandling
)

echo ================実行対象ファイル================
dir %sqlFolder%\*.sql /b
echo ================================================
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION"
if errorlevel 1 ( 
	echo SQLServerへの接続に失敗しました。
	echo サーバー名,ユーザーID,パスワードを確認してください。
	goto ErrorHandling
)

for /F "delims=." %%a in ('dir %sqlFolder%\*.sql /b') do (
	echo %DATE% %TIME:~0,8% %0 %sqlFolder%\%%a.sql 実行開始
	%SQLCMD% -i %sqlFolder%\%%a.sql -b -W -o %resultFolder%\%%a.txt
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %sqlFolder%\%%a.sql 実行終了
)

goto ProcessEnd

:ErrorHandling
rem 異常終了
echo %DATE% %TIME:~0,8% %0 ■異常終了■
exit /b 1

:ProcessEnd
rem 正常終了
echo %DATE% %TIME:~0,8% %0 ■正常終了■
exit /b 0

endlocal
