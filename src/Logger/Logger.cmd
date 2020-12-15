@Echo Off

Rem @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Rem ���O���x��
Rem ���O�ً̋}�x��p�r�ɂ��A�ȉ��̂悤�Ƀ��O���x����ݒ肷��B 
Rem ��Log4j �̃��O���x���𓥏P
Rem �u�o�͐�v�u�^�p���̑Ή��v�́A�e�v���W�F�N�g�̃|���V�[�ɏ����Ă��������B

Rem ���x��	 �T�v			����
Rem FATAL	 �v���I�ȃG���[	�v���O�����ُ̈�I���𔺂��悤�Ȃ��́B�R���\�[�����ɑ����o�͂��邱�Ƃ�z��
Rem ERROR	 �G���[			�\�����Ȃ����̑��̎��s���G���[�B�R���\�[�����ɑ����o�͂��邱�Ƃ�z��
Rem WARN	 �x��			�p�v�f�ƂȂ���API�̎g�p�AAPI�̕s�K�؂Ȏg�p�A�G���[�ɋ߂����ۂȂǁB���s���ɐ������ُ�Ƃ͌����؂�Ȃ�������Ƃ��قȂ鉽�炩�̗\�����Ȃ����
Rem INFO	 ���			���s���̉��炩�̒��ڂ��ׂ����ہi�J�n��I���Ȃǁj�B���b�Z�[�W���e�͊Ȍ��Ɏ~�߂�ׂ�
Rem DEBUG	 �f�o�b�O���	�V�X�e���̓���󋵂Ɋւ���ڍׂȏ��
Rem TRACE	 �g���[�X���	�f�o�b�O�������A�X�ɏڍׂȏ��
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
