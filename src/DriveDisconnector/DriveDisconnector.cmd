Rem ******************処理内容******************
Rem 指定したネットワークドライブを切断する。
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①指定ドライブ
Rem ★パラメータ(%1)が存在した場合にはパラメータを優先する。
Rem ※パラメータは複数設定可能(直書きの場合はカンマ区切り)
if "%1"=="" (
	set drive=T:
) else (
	set drive=Nothing
)

Rem ②ログファイルパス
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_DriveDisconnector_log.txt

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME%:~0,8 %0 ▼処理開始▼ >> %log% 2>&1

if %drive%==Nothing (

	for %%d in (%*) do (
		if not exist %%d (
			echo %%dは存在しません。 >> %log% 2>&1
			goto ErrorHandling
		) else ( 
			echo ================%%d切断処理開始================ >> %log% 2>&1
			net use %%d /delete /YES >> %log% 2>&1
			net use /PERSISTENT:NO >> %log% 2>&1
			if not !ERRORLEVEL!==0 goto ErrorHandling
			echo ================%%d切断処理完了================ >> %log% 2>&1
		)
	)
	
) else (

	for %%a in (%drive%) do (
		if not exist %%a (
			echo %%aは存在しません。 >> %log% 2>&1
			goto ErrorHandling
		) else ( 
			echo ================%%a切断処理開始================ >> %log% 2>&1
			net use %%a /delete /YES >> %log% 2>&1
			net use /PERSISTENT:NO >> %log% 2>&1
			if not !ERRORLEVEL!==0 goto ErrorHandling
			echo ================%%a切断処理完了================ >> %log% 2>&1
		)
	)	
)
goto ProcessEnd

:ErrorHandling
rem 異常終了
echo %DATE% %TIME%:~0,8 %0 ■異常終了■ >> %log% 2>&1
echo エラーが発生したため、処理を中止しました。
echo エラー内容はログファイルを確認してください。
pause
exit /b 1

:ProcessEnd
rem 正常終了
echo %DATE% %TIME%:~0,8 %0 ■正常終了■ >> %log% 2>&1
echo 処理が正常に終了しました。
pause
exit /b 0

endlocal
