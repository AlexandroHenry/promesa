#!/bin/bash

# Flutter 환경별 실행 스크립트 (단일 main.dart 버전)

echo "🚀 Flutter 환경별 실행 도구 (개선된 버전)"
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# 함수: 도움말
show_help() {
    echo "사용법: ./run.sh [환경] [옵션]"
    echo ""
    echo "환경:"
    echo "  prod     🟢 Production - 실제 배포 환경"
    echo "  stg      🟡 Staging - 스테이징 환경"
    echo "  debug    🔵 Debug - 개발 환경"
    echo "  mock     🟣 Mock - Mock 데이터 환경"
    echo ""
    echo "옵션:"
    echo "  -h, --help     도움말 표시"
    echo "  -c, --clean    빌드 전 clean 실행"
    echo "  -r, --release  릴리즈 모드로 실행"
    echo "  -d, --device   특정 디바이스 지정"
    echo ""
    echo "예시:"
    echo "  ./run.sh mock           # Mock 환경으로 실행"
    echo "  ./run.sh debug -c       # Debug 환경으로 clean 후 실행"
    echo "  ./run.sh prod -r        # Production 환경으로 릴리즈 모드 실행"
}

# 함수: 에러 처리
handle_error() {
    echo -e "${RED}❌ 에러: $1${NC}"
    exit 1
}

# 함수: 성공 메시지
success_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

# 함수: 정보 메시지
info_message() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# 함수: 경고 메시지
warning_message() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 함수: 환경별 실행
run_environment() {
    local env=$1
    local clean=$2
    local release=$3
    local device=$4

    case $env in
        "prod")
            echo -e "${GREEN}🟢 Production 환경으로 실행합니다${NC}"
            ENV_COLOR=$GREEN
            ENV_VALUE="production"
            ;;
        "stg")
            echo -e "${YELLOW}🟡 Staging 환경으로 실행합니다${NC}"
            ENV_COLOR=$YELLOW
            ENV_VALUE="staging"
            ;;
        "debug")
            echo -e "${BLUE}🔵 Debug 환경으로 실행합니다${NC}"
            ENV_COLOR=$BLUE
            ENV_VALUE="debug"
            ;;
        "mock")
            echo -e "${PURPLE}🟣 Mock 데이터 환경으로 실행합니다${NC}"
            ENV_COLOR=$PURPLE
            ENV_VALUE="mock"
            ;;
        *)
            handle_error "알 수 없는 환경: $env"
            ;;
    esac

    # Clean 실행
    if [ "$clean" = true ]; then
        info_message "Flutter clean 실행 중..."
        flutter clean || handle_error "Flutter clean 실패"
        info_message "패키지 설치 중..."
        flutter pub get || handle_error "패키지 설치 실패"
    fi

    # 코드 생성 실행
    info_message "코드 생성 실행 중..."
    flutter packages pub run build_runner build --delete-conflicting-outputs || handle_error "코드 생성 실패"

    # Flutter 실행 명령어 구성
    RUN_COMMAND="flutter run --dart-define=ENVIRONMENT=$ENV_VALUE"

    if [ "$release" = true ]; then
        RUN_COMMAND="$RUN_COMMAND --release"
        info_message "릴리즈 모드로 실행합니다"
    fi

    if [ ! -z "$device" ]; then
        RUN_COMMAND="$RUN_COMMAND -d $device"
        info_message "디바이스: $device"
    fi

    echo ""
    echo -e "${ENV_COLOR}🚀 앱을 시작합니다...${NC}"
    echo "실행 명령어: $RUN_COMMAND"
    echo ""

    # 실행
    $RUN_COMMAND
}

# 메인 로직
ENVIRONMENT=""
CLEAN=false
RELEASE=false
DEVICE=""

# 인자 파싱
while [[ $# -gt 0 ]]; do
    case $1 in
        prod|stg|debug|mock)
            ENVIRONMENT="$1"
            shift
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        -r|--release)
            RELEASE=true
            shift
            ;;
        -d|--device)
            DEVICE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            handle_error "알 수 없는 옵션: $1"
            ;;
    esac
done

# 환경이 지정되지 않은 경우
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}❌ 환경을 지정해주세요${NC}"
    echo ""
    show_help
    exit 1
fi

# Flutter 설치 확인
if ! command -v flutter &> /dev/null; then
    handle_error "Flutter가 설치되지 않았습니다"
fi

# 실행
run_environment "$ENVIRONMENT" "$CLEAN" "$RELEASE" "$DEVICE"
