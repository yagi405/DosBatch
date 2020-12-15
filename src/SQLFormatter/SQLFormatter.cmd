Rem ******************処理内容******************
Rem 指定したフォルダに格納されているSQLファイルを全て以下のルールに従い整形する。
Rem ①2行目に「:Error stdout」を挿入
Rem ②「Go」を削除
Rem ********************************************

@echo off
setlocal EnableDelayedExpansion
pushd %0\..
cls

Rem ******************設定情報******************

Rem ①処理対象SQLファイル格納先フォルダ
set sqlFolder=%0\..\SQL

Rem ②行挿入用テンプレートファイルパス
set insertFile=%~0\..\InsertTemplate.txt

Rem ③実行結果格納先フォルダ
set resultFolder=%~0\..\SQL_Result

Rem ④ログファイルパス
set logFolder=%~0\..\Log
set log=%logFolder%\%DATE:/=%_SQLFormatter_log.txt

Rem ⑤書き込み用一時ファイル
Rem ※既存ファイルと同名にしないよう注意
set tempFile=%0\..\tmp.sql

Rem ********************************************

if not exist %logFolder% (mkdir %logFolder%)
if errorlevel 1 goto ErrorHandling

echo %DATE% %TIME:~0,8% %0 ▼処理開始▼ >> %log% 2>&1

chcp 932 >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

if not exist %resultFolder% (mkdir %resultFolder% >> %log% 2>&1)
if errorlevel 1 goto ErrorHandling

if not exist %sqlFolder% (
	echo %sqlFolder%が存在しません。 >> %log% 2>&1
	goto ErrorHandling
)

echo ================実行対象ファイル================ >> %log% 2>&1
dir %sqlFolder%\*.sql /b >> %log% 2>&1
echo ================================================ >> %log% 2>&1
if errorlevel 1 goto ErrorHandling

for /f %%a in ('dir %sqlFolder%\*.sql /b') do call :Writer %%a >> %log% 2>&1

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
