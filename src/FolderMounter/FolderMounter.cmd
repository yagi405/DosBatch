Rem ******************処理内容******************
Rem 1.指定フォルダを仮想ドライブとしてマウント
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************
Rem ①指定フォルダパス
set targetFolder=""
Rem ②仮想ドライブ
set drive=T:
Rem ③ログファイルパス
set log=%0\..\FolderMounter_log.txt
Rem ********************************************

echo %DATE% %TIME%:~0,8 %0 ▼処理開始▼ >> %log% 2>&1

if not exist %targetFolder% (
 	echo %targetFolder%が存在しません。 >> %log% 2>&1
 	goto ErrorHandling
)else if exist %drive% (
	echo %drive%はすでに使用されています。 >> %log% 2>&1
	goto ErrorHandling
)

net use %drive% %targetFolder% >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

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
