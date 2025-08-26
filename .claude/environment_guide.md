# 환경별 실행 가이드 (개선된 버전)

## 🚀 환경 모드

### 1. 🟢 Production (운영)
- 실제 운영 서버 API 사용
- 로깅 비활성화
- 에러 리포팅 활성화
- 배너 숨김

### 2. 🟡 Staging (스테이징)  
- 스테이징 서버 API 사용
- 로깅 활성화
- 에러 리포팅 활성화
- 환경 배너 표시

### 3. 🔵 Debug (개발)
- 개발 서버 API 사용
- 로깅 활성화
- 긴 타임아웃 설정
- 환경 배너 표시

### 4. 🟣 Mock (목 데이터)
- **실제 API 호출 없음**
- 로컬 JSON 데이터 사용
- 네트워크 지연 시뮬레이션
- 랜덤 에러 시뮬레이션 (10% 확률)
- 환경 배너 표시

## 🛠️ 실행 방법 (단일 main.dart 사용)

### 터미널 스크립트 사용

#### macOS/Linux
```bash
# 실행 권한 부여 (최초 1회)
chmod +x scripts/run.sh

# 환경별 실행
./scripts/run.sh mock          # Mock 데이터 환경
./scripts/run.sh debug         # Debug 환경  
./scripts/run.sh stg           # Staging 환경
./scripts/run.sh prod          # Production 환경

# 옵션 사용
./scripts/run.sh mock -c       # Clean 후 실행
./scripts/run.sh prod -r       # Release 모드
./scripts/run.sh debug -c -r   # Clean 후 Release 모드
```

#### Windows
```cmd
# 환경별 실행
scripts\run.bat mock          # Mock 데이터 환경
scripts\run.bat debug         # Debug 환경
scripts\run.bat stg           # Staging 환경  
scripts\run.bat prod          # Production 환경

# 옵션 사용
scripts\run.bat mock -c       # Clean 후 실행
scripts\run.bat prod -r       # Release 모드
```

### VS Code 사용
1. `Ctrl/Cmd + Shift + P` → "Debug: Select and Start Debugging"
2. 원하는 환경 선택:
   - 🟢 Production
   - 🟡 Staging  
   - 🔵 Debug
   - 🟣 Mock Data

### 직접 Flutter 명령어 사용
```bash
# Mock 환경
flutter run --dart-define=ENVIRONMENT=mock

# Debug 환경  
flutter run --dart-define=ENVIRONMENT=debug

# Staging 환경
flutter run --dart-define=ENVIRONMENT=staging

# Production 환경
flutter run --dart-define=ENVIRONMENT=production

# 또는 줄여서
flutter run --dart-define=ENVIRONMENT=prod
flutter run --dart-define=ENVIRONMENT=stg
```

## ✨ 개선된 점

### 🗂️ 파일 구조 단순화
**기존**: 여러 main 파일
```
lib/
├── main.dart
├── main_staging.dart
├── main_debug.dart
└── main_mock.dart
```

**개선**: 단일 main 파일
```
lib/
└── main.dart  # 하나의 파일로 모든 환경 처리
```

### 🎯 dart-define 방식의 장점
- ✅ **표준 방식**: Flutter 공식 권장 방법
- ✅ **파일 수 감소**: main 파일 하나로 통합
- ✅ **CI/CD 친화적**: 빌드 시 환경 쉽게 지정
- ✅ **Android/iOS flavor와 호환**: 추후 네이티브 빌드 설정과 연동 가능

### 🔄 환경 전환 방식
```dart
// dart-define에서 환경 읽기
Environment _getEnvironmentFromDefine() {
  const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'debug');
  
  switch (envString.toLowerCase()) {
    case 'production':
    case 'prod':
      return Environment.production;
    case 'staging':
    case 'stg':
      return Environment.staging;
    case 'debug':
    case 'dev':
      return Environment.debug;
    case 'mock':
      return Environment.mock;
    default:
      return Environment.debug; // 기본값
  }
}
```

## 🎭 Mock 데이터 특징 (변경 없음)

### Mock 데이터 소스
- `assets/mock_data/users.json` - 사용자 데이터
- `assets/mock_data/products.json` - 상품 데이터  
- `assets/mock_data/api_responses.json` - API 응답 템플릿

### Mock 동작 방식
- **네트워크 지연**: 500-1500ms 랜덤 지연
- **에러 시뮬레이션**: 10% 확률로 네트워크 오류 발생
- **페이지네이션**: 실제 API와 동일한 구조
- **검색/필터링**: 클라이언트 사이드 필터링

## 🔧 개발 중 환경 전환

### 런타임에 Repository 전환 (변경 없음)
```dart
// Mock으로 전환
switchToMockRepository();

// API로 전환  
switchToApiRepository();
```

### 환경 확인
```dart
// 현재 환경 확인
print(AppConfig.environment);
print(AppConfig.useMockData);
print(AppConfig.baseUrl);
```

## 📱 앱에서 환경 정보 확인 (변경 없음)

- **배너**: 화면 우상단에 환경 표시 (Production 제외)
- **앱 타이틀**: "Flutter App 🟣 MOCK" 형태로 표시
- **로그**: 콘솔에서 환경 정보 확인 가능

## 🚀 CI/CD 빌드 예시

### GitHub Actions
```yaml
- name: Build APK (Production)
  run: flutter build apk --dart-define=ENVIRONMENT=production

- name: Build APK (Staging)  
  run: flutter build apk --dart-define=ENVIRONMENT=staging
```

### Fastlane
```ruby
lane :build_production do
  sh("flutter build ios --dart-define=ENVIRONMENT=production")
end

lane :build_staging do
  sh("flutter build ios --dart-define=ENVIRONMENT=staging")
end
```

## ⚠️ 주의사항 (변경 없음)

### Mock 환경
- 실제 서버 API 호출 없음
- 로그인/인증 토큰은 가짜 값
- 데이터 영속성 없음 (앱 재시작시 초기화)

### Production 환경
- 실제 서버에 데이터가 저장됨
- 신중하게 테스트 진행
- 디버그 정보 제한적

## 🔄 마이그레이션 가이드

기존 여러 main 파일을 사용하던 프로젝트에서 전환하려면:

1. **기존 파일 삭제**
   ```bash
   rm lib/main_staging.dart
   rm lib/main_debug.dart  
   rm lib/main_mock.dart
   ```

2. **새로운 main.dart 사용**
   - 환경을 dart-define으로 받아서 처리

3. **스크립트 업데이트**
   - `--dart-define=ENVIRONMENT=환경명` 방식 사용

4. **VS Code 설정 업데이트**
   - launch.json에서 args로 dart-define 전달

이 방식이 **Flutter 표준 방식**이며, 대부분의 Flutter 프로젝트에서 사용하는 방법입니다! 🎉
