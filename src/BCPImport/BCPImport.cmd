Rem ******************処理内容******************
Rem 指定したフォルダに格納されているdatファイルを全てBCPで取り込む。
Rem datファイル名(拡張子抜き)がインポート先テーブルとなる。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①処理対象datファイル格納フォルダ
set bcpFolder=%0\..\BCP

Rem ②SQLServer名
set serverName=

Rem ③DB名
set dbName=

Rem ④SQLServerパスワード
set passWord=

Rem ⑤SQLServerユーザーID
set userID=

Rem ⑥ログファイルパス
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

echo ================処理対象ファイル================ >> %log% 2>&1
dir %bcpFolder%\*.dat /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

%SQLCMD% -Q "SELECT @@VERSION" >> %log% 2>&1
if errorlevel 1 ( 
	echo SQLServerへの接続に失敗しました。 >> %log% 2>&1
	echo サーバー名,ユーザーID,パスワードを確認してください。 >> %log% 2>&1
	goto ErrorHandling
)

for /f "delims=." %%a in ('dir %bcpFolder%\*.dat /b') do (
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.dat インポート開始 >> %log% 2>&1
	BCP %dbName%%%a in %bcpFolder%\%%a.dat -n -E -S %serverName% -U %userID% -P %passWord% >> %log% 2>&1
	if errorlevel 1 goto ErrorHandling
	echo %DATE% %TIME:~0,8% %0 %bcpFolder%\%%a.dat インポート終了 >> %log% 2>&1
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
