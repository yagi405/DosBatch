Rem ******************処理内容******************
Rem 指定したSQLServerエージェントのジョブを実行する
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %~dp0
cls

Rem ******************設定情報******************
Rem if "%1" == "" goto ErrorHandling
if "%2" == "" goto ErrorHandling
if "%3" == "" goto ErrorHandling
if "%4" == "" goto ErrorHandling
if "%5" == "" goto ErrorHandling

Rem ①実行ジョブ名
set jobName=%~1
Rem ②SQLServer名
set serverName=%~2
Rem ③SQLServerパスワード
set passWord=%~3
Rem ④SQLServerユーザーID
set userID=%~4
Rem ⑤ジョブ情報(実行結果)出力ファイルパス
set jobInfo=%~5
Rem ⑥ジョブ成否判定用キーワード
set successKeyWord=ジョブは成功しました
set failureKeyWord=ジョブは失敗しました
Rem ********************************************

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼
echo %jobName%

set SQLCMD=sqlcmd -S %serverName% -U %userID% -P %passWord%

echo %SQLCMD%

%SQLCMD% -Q "SELECT @@VERSION"
if errorlevel 1 ( 
	echo SQLServerへの接続に失敗しました。
	echo サーバー名,ユーザーID,パスワードを確認してください。
	goto ErrorHandling
)

echo %DATE% %TIME:~0,8% %0 %jobName% 実行開始
%SQLCMD% -d msdb -Q"sp_start_job'%jobName%'" -b
if errorlevel 1 goto ErrorHandling

rem ジョブの終了を60秒待つ
timeout 60 > null

%SQLCMD% -d msdb -Q"sp_help_job @job_name ='%jobName%'" -b -s, -W -o %jobInfo%
if errorlevel 1 goto ErrorHandling
echo %DATE% %TIME:~0,8% %0 %jobName% 実行終了

findstr %successKeyWord% %jobInfo%
if errorlevel 1 (
	findstr %failureKeyWord% %jobInfo%
	goto ErrorHandling
)

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
