# 🚀 Flutter Clean Architecture Boilerplate

환경별 실행과 Mock 데이터를 지원하는 Flutter 앱 보일러플레이트입니다.

## ✨ 주요 특징

### 🏗️ Clean Architecture
- **3계층 구조**: Presentation → Domain → Data
- **의존성 주입**: GetIt을 통한 느슨한 결합
- **상태 관리**: Riverpod으로 반응형 상태 관리

### 🌍 환경별 실행 지원 (단일 main.dart)
- **🟢 Production**: 실제 운영 서버
- **🟡 Staging**: 스테이징 서버  
- **🔵 Debug**: 개발 서버
- **🟣 Mock**: Mock 데이터 (서버 없이 개발 가능!)

### 🎭 완전한 Mock 시스템
- 실제 API 호출 없이 개발 가능
- 네트워크 지연 및 에러 시뮬레이션
- JSON 기반 Mock 데이터 관리

### 🎨 일관된 디자인 시스템
- Material 3 디자인
- Light/Dark 테마 지원
- Pretendard 폰트 (한글 최적화)
- 체계적인 색상 팔레트

## 🚀 빠른 시작

### 1. 프로젝트 설정
```bash
# 의존성 설치
flutter pub get

# 코드 생성
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 2. 환경별 실행

#### 스크립트 사용 (권장)
```bash
# 실행 권한 부여 (macOS/Linux, 최초 1회)
chmod +x scripts/run.sh

# Mock 환경 실행 (서버 없이 개발)
./scripts/run.sh mock

# 다른 환경들
./scripts/run.sh debug    # 개발 서버
./scripts/run.sh stg      # 스테이징 서버  
./scripts/run.sh prod     # 운영 서버
```

#### Windows
```cmd
scripts\run.bat mock      # Mock 환경
scripts\run.bat debug     # 개발 서버
```

#### VS Code
1. `F5` 키 또는 Run and Debug
2. 원하는 환경 선택 (🟣 Mock Data 권장)

#### 직접 Flutter 명령어
```bash
# Mock 환경
flutter run --dart-define=ENVIRONMENT=mock

# 다른 환경들
flutter run --dart-define=ENVIRONMENT=debug
flutter run --dart-define=ENVIRONMENT=stg
flutter run --dart-define=ENVIRONMENT=prod
```

## 📁 프로젝트 구조

```
lib/
├── 📁 core/              # 공통 기능
│   ├── config/           # 환경별 설정
│   ├── theme/            # 디자인 시스템
│   ├── network/          # 네트워크 설정
│   ├── di/               # 의존성 주입
│   └── router/           # 라우팅
├── 📁 data/              # 데이터 레이어
│   ├── datasources/      # API/Mock 데이터 소스
│   ├── models/           # 데이터 모델
│   └── repositories/     # Repository 구현체
├── 📁 domain/            # 도메인 레이어
│   ├── entities/         # 비즈니스 엔티티
│   ├── repositories/     # Repository 인터페이스
│   └── usecases/         # 비즈니스 로직
└── 📁 presentation/      # UI 레이어
    ├── screens/          # 화면 (Scaffold 포함)
    ├── fragments/        # 화면 조각
    ├── views/            # 재사용 위젯
    ├── providers/        # 상태 관리
    └── widgets/          # 공통 위젯
```

## 🎭 Mock 데이터 시스템

### Mock 데이터 위치
```
assets/mock_data/
├── users.json           # 사용자 데이터
├── products.json        # 상품 데이터
└── api_responses.json   # API 응답 템플릿
```

### Mock 특징
- ✅ **실제 API 호출 없음** - 완전히 오프라인 개발
- ✅ **네트워크 지연 시뮬레이션** - 실제와 유사한 경험
- ✅ **랜덤 에러 발생** - 에러 처리 테스트 가능
- ✅ **페이지네이션 지원** - 실제 API와 동일한 구조

### Mock 환경 장점
- 🚫 **서버 의존성 없음** - 백엔드 없이도 프론트엔드 개발 가능
- ⚡ **빠른 개발** - 네트워크 지연 없이 빠른 테스트
- 🧪 **안정적인 테스트** - 일관된 데이터로 예측 가능한 테스트
- 💡 **UI/UX 집중** - 데이터 처리 로직에 신경쓰지 않고 UI 개발

## 🔧 기술 스택

### 핵심 라이브러리
- **flutter_riverpod**: 상태 관리
- **get_it**: 의존성 주입
- **auto_route**: 라우팅
- **retrofit + dio**: API 통신
- **freezed**: 불변 객체
- **google_fonts**: 폰트 관리

### 개발 도구
- **build_runner**: 코드 생성
- **riverpod_lint**: Riverpod 규칙 검사
- **flutter_lints**: 코드 품질 관리

## 🎨 디자인 시스템

### 색상 팔레트
- **Primary**: Indigo (#6366F1)
- **Secondary**: Emerald (#10B981)
- **Accent**: Amber (#F59E0B)

### 폰트
- **주 폰트**: Pretendard (한글 최적화)
- **보조 폰트**: Inter
- **자동 폴백**: 네트워크 연결 상태에 따라 자동 전환

## 📱 구현된 기능 예제

### 사용자 관리 시스템
- ✅ **사용자 목록** - 페이지네이션, 검색, 무한 스크롤
- ✅ **에러 처리** - 네트워크 오류, 재시도 로직
- ✅ **Empty State** - 데이터 없을 때 친화적 UI
- ✅ **로딩 상태** - 스켈레톤 UI, 로딩 인디케이터

### Clean Architecture 패턴
```dart
// UseCase (비즈니스 로직)
class GetUsersUseCase {
  Future<({Failure? failure, List<User>? users})> call() async {
    // 입력값 검증 + 비즈니스 로직
  }
}

// Provider (상태 관리)
@riverpod  
class UserListNotifier extends _$UserListNotifier {
  // BuildContext 사용 안함!
  // UseCase를 통한 순수한 상태 관리
}

// Screen (UI)
class UserListScreen extends ConsumerWidget {
  // BuildContext 사용 가능
  // Provider 구독 및 UI 렌더링
}
```

## 🔄 환경별 설정

### 단일 main.dart로 환경 관리
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
      return Environment.debug;
  }
}
```

### API 엔드포인트
```dart
// lib/core/config/app_config.dart
static String get baseUrl {
  switch (environment) {
    case Environment.production:
      return 'https://api.prod.example.com';
    case Environment.staging:
      return 'https://api.stg.example.com';
    case Environment.debug:
      return 'https://api.dev.example.com';
    case Environment.mock:
      return 'mock'; // 실제로는 사용되지 않음
  }
}
```

### 환경별 차이점
| 환경 | API 호출 | 로깅 | 배너 | 타임아웃 |
|------|----------|------|------|----------|
| Production | ✅ 운영 서버 | ❌ | ❌ | 30초 |
| Staging | ✅ 스테이징 서버 | ✅ | ✅ | 30초 |
| Debug | ✅ 개발 서버 | ✅ | ✅ | 60초 |
| Mock | ❌ Mock 데이터만 | ✅ | ✅ | 5초 |

## 🚀 CI/CD 빌드

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
```

## 📖 상세 문서

프로젝트의 상세한 가이드는 `.claude/` 폴더에서 확인할 수 있습니다:

- `project_guidelines.md` - 프로젝트 규칙과 아키텍처
- `folder_structure.md` - 폴더 구조와 명명 규칙
- `development_guide.md` - 개발 가이드 및 명령어
- `environment_guide.md` - 환경별 실행 가이드

## 🤝 기여하기

### 새로운 기능 추가 순서
1. **Domain**: Entity → Repository Interface → UseCase
2. **Data**: Model → DataSource → Repository Implementation  
3. **Presentation**: Provider → Screen → Fragment → View
4. **DI**: 의존성 주입 등록

### 코딩 규칙
- ❌ Provider에서 BuildContext 사용 금지
- ✅ 순수한 Dart 클래스만 사용
- ✅ UseCase를 통한 비즈니스 로직 처리
- ✅ State 변경만 수행 (직접 데이터 수정 금지)

## ✨ 개선된 점 (v2.0)

### 🗂️ 파일 구조 단순화
**기존**: 여러 main 파일 방식
```
lib/
├── main.dart
├── main_staging.dart  ❌ 삭제됨
├── main_debug.dart    ❌ 삭제됨
└── main_mock.dart     ❌ 삭제됨
```

**개선**: 단일 main.dart + dart-define
```
lib/
└── main.dart  ✅ 하나의 파일로 모든 환경 처리
```

### 🎯 dart-define 방식의 장점
- ✅ **Flutter 공식 표준**: 권장되는 환경 설정 방식
- ✅ **CI/CD 친화적**: 빌드 시 환경 쉽게 지정
- ✅ **파일 수 감소**: 관리할 파일이 줄어듦
- ✅ **확장성**: Android/iOS flavor와 연동 가능

## 📄 라이선스

MIT License

---

💡 **개발 팁**: Mock 환경에서 시작하여 UI/UX를 완성한 후, 실제 API 연동을 진행하세요!

🎉 **v2.0 개선사항**: 단일 main.dart 파일로 더 깔끔하고 표준적인 구조로 업그레이드!

dart run build_runner build --delete-conflicting-outputs# Boilerplate
