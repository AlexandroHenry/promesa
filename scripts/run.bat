@echo off
setlocal enabledelayedexpansion

REM Flutter 환경별 실행 스크립트 (Windows, 단일 main.dart 버전)

echo 🚀 Flutter 환경별 실행 도구 (개선된 버전)
echo.

REM 함수: 도움말
if "%1"=="help" goto :show_help
if "%1"=="-h" goto :show_help
if "%1"=="--help" goto :show_help

REM 함수: 에러 처리
:handle_error
echo ❌ 에러: %1
exit /b 1

REM 함수: 성공 메시지
:success_message
echo ✅ %1
goto :eof

REM 함수: 정보 메시지
:info_message
echo ℹ️  %1
goto :eof

REM 함수: 도움말
:show_help
echo 사용법: run.bat [환경] [옵션]
echo.
echo 환경:
echo   prod     🟢 Production - 실제 배포 환경
echo   stg      🟡 Staging - 스테이징 환경
echo   debug    🔵 Debug - 개발 환경
echo   mock     🟣 Mock - Mock 데이터 환경
echo.
echo 옵션:
echo   -h, --help     도움말 표시
echo   -c, --clean    빌드 전 clean 실행
echo   -r, --release  릴리즈 모드로 실행
echo.
echo 예시:
echo   run.bat mock           # Mock 환경으로 실행
echo   run.bat debug -c       # Debug 환경으로 clean 후 실행
echo   run.bat prod -r        # Production 환경으로 릴리즈 모드 실행
exit /b 0

REM 변수 초기화
set ENVIRONMENT=
set CLEAN=false
set RELEASE=false
set ENV_VALUE=

REM 인자 파싱
:parse_args
if "%1"=="" goto :validate_environment

if "%1"=="prod" (
    set ENVIRONMENT=prod
    set ENV_VALUE=production
    shift
    goto :parse_args
)
if "%1"=="stg" (
    set ENVIRONMENT=stg
    set ENV_VALUE=staging
    shift
    goto :parse_args
)
if "%1"=="debug" (
    set ENVIRONMENT=debug
    set ENV_VALUE=debug
    shift
    goto :parse_args
)
if "%1"=="mock" (
    set ENVIRONMENT=mock
    set ENV_VALUE=mock
    shift
    goto :parse_args
)
if "%1"=="-c" (
    set CLEAN=true
    shift
    goto :parse_args
)
if "%1"=="--clean" (
    set CLEAN=true
    shift
    goto :parse_args
)
if "%1"=="-r" (
    set RELEASE=true
    shift
    goto :parse_args
)
if "%1"=="--release" (
    set RELEASE=true
    shift
    goto :parse_args
)

call :handle_error "알 수 없는 옵션: %1"

:validate_environment
if "%ENVIRONMENT%"=="" (
    echo ❌ 환경을 지정해주세요
    echo.
    goto :show_help
)

REM Flutter 설치 확인
flutter --version >nul 2>&1
if errorlevel 1 call :handle_error "Flutter가 설치되지 않았습니다"

REM 환경별 실행
if "%ENVIRONMENT%"=="prod" (
    echo 🟢 Production 환경으로 실행합니다
)
if "%ENVIRONMENT%"=="stg" (
    echo 🟡 Staging 환경으로 실행합니다
)
if "%ENVIRONMENT%"=="debug" (
    echo 🔵 Debug 환경으로 실행합니다
)
if "%ENVIRONMENT%"=="mock" (
    echo 🟣 Mock 데이터 환경으로 실행합니다
)

REM Clean 실행
if "%CLEAN%"=="true" (
    call :info_message "Flutter clean 실행 중..."
    flutter clean
    if errorlevel 1 call :handle_error "Flutter clean 실패"
    
    call :info_message "패키지 설치 중..."
    flutter pub get
    if errorlevel 1 call :handle_error "패키지 설치 실패"
)

REM 코드 생성 실행
call :info_message "코드 생성 실행 중..."
flutter packages pub run build_runner build --delete-conflicting-outputs
if errorlevel 1 call :handle_error "코드 생성 실패"

REM Flutter 실행 명령어 구성
set RUN_COMMAND=flutter run --dart-define=ENVIRONMENT=%ENV_VALUE%

if "%RELEASE%"=="true" (
    set RUN_COMMAND=%RUN_COMMAND% --release
    call :info_message "릴리즈 모드로 실행합니다"
)

echo.
echo 🚀 앱을 시작합니다...
echo 실행 명령어: %RUN_COMMAND%
echo.

REM 실행
%RUN_COMMAND%
