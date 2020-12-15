@Echo Off

Rem @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Rem ログレベル
Rem ログの緊急度や用途により、以下のようにログレベルを設定する。 
Rem ※Log4j のログレベルを踏襲
Rem 「出力先」「運用時の対応」は、各プロジェクトのポリシーに準じてください。

Rem レベル	 概要			説明
Rem FATAL	 致命的なエラー	プログラムの異常終了を伴うようなもの。コンソール等に即時出力することを想定
Rem ERROR	 エラー			予期しないその他の実行時エラー。コンソール等に即時出力することを想定
Rem WARN	 警告			廃要素となったAPIの使用、APIの不適切な使用、エラーに近い事象など。実行時に生じた異常とは言い切れないが正常とも異なる何らかの予期しない問題
Rem INFO	 情報			実行時の何らかの注目すべき事象（開始や終了など）。メッセージ内容は簡潔に止めるべき
Rem DEBUG	 デバッグ情報	システムの動作状況に関する詳細な情報
Rem TRACE	 トレース情報	デバッグ情報よりも、更に詳細な情報
Rem @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Call :InitialSetting
For %%l In (%LAVEL_NAMES%) Do If "%1"=="%%l" Call :%* & Exit /b
Call :ErrorHandling InitialSetting - ArgumentException - %*
Exit /b

Rem **********************************************************************************

:InitialSetting
Set LAVEL_NAMES=SetFile,SetLevel,TRACE,DEBUG,INFO,WARN,ERROR,FATAL
GOTO :EOF

Rem **********************************************************************************

:ErrorHandling
Echo %~nx0 - %* 
Pause
GOTO :EOF

Rem **********************************************************************************

:EchoEx

echo %DATE% %TIME% %*
if not "%LOG_FILE%"=="" (
    echo  %DATE% %TIME% %* >> %LOG_FILE% 2>&1
)
GOTO :EOF

Rem **********************************************************************************

:SetFile
If Not "%1"=="" (
	Set LOG_FILE=%1
          TYPE nul > "%LOG_FILE%"
) ELSE (
	Call :ErrorHandling SetFile - ArgumentException - %*
)
GOTO :EOF

Rem **********************************************************************************

:SetLevel
If Not "%1"=="" (	
	If Not %1 LEQ 6 (
		If %1 GEQ 1 (
			Set LOG_LEVEL=%1 
		)
	) Else (	
        If "%1"=="TRACE" (
            Set LOG_LEVEL=1
        )
        If "%1"=="DEBUG" (
            Set LOG_LEVEL=2
        )
        If "%1"=="INFO" (
            Set LOG_LEVEL=3
        )
        If "%1"=="WARN" (
            Set LOG_LEVEL=4
        )
        If "%1"=="ERROR" (
            Set LOG_LEVEL=5
        )
        If "%1"=="FATAL" (
            Set LOG_LEVEL=6
        )
	)	
) Else (
	Call :ErrorHandling SetLevel - ArgumentException - %1
)
If Not Defined LOG_LEVEL (
	Call :ErrorHandling SetLevel - ArgumentException - %1
)
GOTO :EOF

Rem **********************************************************************************

:TRACE
Set LOG_LEVEL=1
Call :EchoEx TRACE %*
GOTO :EOF

Rem **********************************************************************************

:DEBUG
Set LOG_LEVEL=2
Call :EchoEx DEBUG %*
GOTO :EOF

Rem **********************************************************************************

:INFO
Set LOG_LEVEL=3
Call :EchoEx INFO %*
GOTO :EOF

Rem **********************************************************************************

:WARN
Set LOG_LEVEL=4
Call :EchoEx WARN %*
GOTO :EOF

Rem **********************************************************************************

:ERROR
Set LOG_LEVEL=5
Call :EchoEx ERROR %*
GOTO :EOF

Rem **********************************************************************************

:FATAL
Set LOG_LEVEL=6
Call :EchoEx FATAL %*
GOTO :EOF

Rem **********************************************************************************
