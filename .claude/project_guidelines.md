# Flutter 프로젝트 가이드라인 (v2.0)

## 📋 프레임워크 버전
- Flutter 3.32.0 이상
- Dart 3.8.0 이상

## 🔧 핵심 라이브러리
- **상태 관리**: flutter_riverpod, riverpod_annotation
- **의존성 주입**: get_it  
- **페이지 라우팅**: auto_route
- **네트워크 통신**: retrofit, dio
- **폰트**: google_fonts (Pretendard)
- **JSON 직렬화**: json_annotation, freezed_annotation

## 🏗️ Widget 구조 (3단계)
```
Screen > Fragment > View
```

### 각 레벨 설명
- **Screen**: Scaffold를 포함한 최상단 Widget (필수)
- **Fragment**: Screen보다 작고 View보다 큰 단위의 Widget (선택적)
  - tab, bottomtab 등으로 페이지 단위가 아닌 transition 화면
- **View**: 다양한 크기의 Widget (선택적)

## 🎯 레이어 구조 (Clean Architecture)
```
📁 lib/
├── 📁 core/          # 모든 레이어에서 사용가능한 공통 기능
│   ├── config/       # 환경별 설정 ✨NEW
│   ├── theme/        # 앱 테마, 색상, 폰트 ✨NEW
│   ├── constants/    # 상수 정의
│   ├── errors/       # 에러 클래스
│   ├── network/      # 네트워크 설정
│   ├── di/          # 의존성 주입
│   ├── router/      # 라우팅
│   └── utils/       # 유틸리티
├── 📁 data/          # 데이터 레이어
│   ├── datasources/  # API/Local/Mock 데이터 소스 (Mock 추가!)
│   ├── models/      # JSON 직렬화 모델
│   └── repositories/# Repository 구현체
├── 📁 domain/        # 도메인 레이어
│   ├── entities/    # 비즈니스 엔티티
│   ├── repositories/# Repository 인터페이스
│   └── usecases/    # 비즈니스 로직 (UseCase 예제 추가!)
└── 📁 presentation/ # 프레젠테이션 레이어
    ├── screens/     # Scaffold 포함 최상단 위젯
    ├── fragments/   # 중간 크기 위젯
    ├── views/       # 작은 재사용 위젯
    ├── providers/   # Riverpod 상태 관리
    └── widgets/     # 공통 위젯
```

## 🌍 환경별 실행 모드 (v2.0 개선!)

### 단일 main.dart + dart-define 방식
**기존 (v1.0)**: 여러 main 파일
```
lib/
├── main.dart
├── main_staging.dart  ❌ 복잡함
├── main_debug.dart    ❌ 관리 어려움
└── main_mock.dart     ❌ 파일 많음
```

**개선 (v2.0)**: 단일 main.dart
```
lib/
└── main.dart  ✅ 하나의 파일로 모든 환경 처리
```

### 4가지 환경 지원
- **🟢 Production**: 실제 운영 서버
- **🟡 Staging**: 스테이징 서버  
- **🔵 Debug**: 개발 서버
- **🟣 Mock**: Mock 데이터 (실제 API 호출 없음)

### 실행 방법
```bash
# 스크립트 사용 (권장)
./scripts/run.sh mock     # Mock 환경
./scripts/run.sh debug    # Debug 환경
./scripts/run.sh stg      # Staging 환경
./scripts/run.sh prod     # Production 환경

# 직접 Flutter 명령어
flutter run --dart-define=ENVIRONMENT=mock
flutter run --dart-define=ENVIRONMENT=debug
flutter run --dart-define=ENVIRONMENT=stg
flutter run --dart-define=ENVIRONMENT=prod

# VS Code에서 F5로 실행 가능
```

## 🎨 디자인 시스템

### 색상 시스템
- **Primary**: Indigo 계열 (`#6366F1`)
- **Secondary**: Emerald 계열 (`#10B981`)  
- **Accent**: Amber 계열 (`#F59E0B`)
- **Error/Warning/Success/Info**: 각각 체계적인 색상 팔레트
- **Light/Dark 테마 완벽 지원**

### 폰트 시스템
- **주 폰트**: Pretendard (한글 최적화)
- **보조 폰트**: Inter
- **Google Fonts 자동 로드** (네트워크 연결시)
- **Fallback 지원** (오프라인시 로컬 폰트)

### 컴포넌트 스타일
- **Material 3 디자인**
- **일관된 BorderRadius (12px, 16px)**
- **그림자 효과 최소화**
- **Outline 기반 카드 디자인**

## ⚠️ View/State 관계 규칙 (중요!)

### ❌ 금지사항
- state에서 BuildContext 참조 또는 파라미터 사용 금지
- state에서 view에 의존하는 코드 작성 금지
- state에서 직접 데이터 수정 금지

### ✅ 준수사항
- state에서는 순수한 dart 클래스만 사용
- state에서는 usecase의 데이터 가져오기 성공/실패 처리만
- state에서는 state 변경 작업만 수행
- BuildContext는 view에서만 사용
- 예외 사항 발생시 팀 논의 후 해결

## 🔄 Mock 데이터 시스템

### Mock 데이터 특징
- **실제 API 호출 없음**: 완전히 로컬에서 동작
- **네트워크 지연 시뮬레이션**: 500-1500ms 랜덤
- **에러 시뮬레이션**: 10% 확률로 네트워크 오류
- **페이지네이션 지원**: 실제 API와 동일한 구조
- **검색/필터링**: 클라이언트 사이드 처리

### Mock 데이터 위치
```
assets/mock_data/
├── users.json           # 사용자 데이터
├── products.json        # 상품 데이터
└── api_responses.json   # API 응답 템플릿
```

### Mock 사용 예제
```dart
// Mock 환경에서 자동으로 MockDataSource 사용
final result = await userRepository.getUsers();
// → assets/mock_data/users.json에서 데이터 로드
```

## 🔗 네트워크 통신

### 환경별 자동 분기
- **Mock 환경**: MockDataSource 사용, 실제 API 호출 차단
- **기타 환경**: Retrofit + Dio 사용

### API 에러 처리
```dart
// Repository에서 Failure 객체로 통일
({Failure? failure, List<User>? users}) result = await repository.getUsers();

if (result.failure != null) {
  // 에러 처리
} else {
  // 성공 처리
}
```

## 📱 실제 구현된 기능

### 사용자 관리 시스템
- **사용자 목록 조회** (페이지네이션)
- **사용자 검색** (실시간 검색)
- **무한 스크롤** (자동 추가 로드)
- **Pull-to-Refresh** (당겨서 새로고침)
- **에러 처리** (재시도 버튼)
- **Empty State** (빈 상태 UI)

### UseCase 예제
- `GetUsersUseCase`: 입력값 검증 + 비즈니스 로직
- `GetUserUseCase`: 단일 사용자 조회
- `CreateUserUseCase`: 복잡한 검증 로직 포함

### Provider 패턴
```dart
@riverpod
class UserListNotifier extends _$UserListNotifier {
  // BuildContext 사용 안함!
  // UseCase를 통한 데이터 처리만
  // State 변경만 수행
}
```

## 🚀 시작하기

### 1. 의존성 설치
```bash
flutter pub get
```

### 2. 코드 생성
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3. 실행 (Mock 환경 권장)
```bash
./scripts/run.sh mock
```

### 4. VS Code 설정
- F5 키로 디버깅 가능
- 환경별 Launch Configuration 제공

## 📖 추가 문서
- `folder_structure.md` - 상세 폴더 구조
- `development_guide.md` - 개발 가이드  
- `environment_guide.md` - 환경별 실행 가이드

## 🔮 향후 확장
- **Firebase 연결**: pubspec.yaml에 주석으로 준비됨
- **테스트**: 폴더 구조 준비완료
- **CI/CD**: 환경별 빌드 설정 가능
- **다국어**: i18n 구조 확장 가능
- **Android/iOS Flavor**: dart-define과 연동 가능

## ✨ v2.0 주요 개선사항

### 🗂️ 구조 단순화
- **단일 main.dart**: 여러 main 파일 → 하나의 파일
- **dart-define 사용**: Flutter 공식 권장 방식
- **CI/CD 친화적**: 빌드 시 환경 쉽게 지정

### 🎯 표준화
- **Flutter 표준 방식**: 대부분의 Flutter 프로젝트에서 사용
- **확장성**: Android/iOS flavor와 호환
- **유지보수성**: 관리할 파일 수 감소

### 🔧 개발 편의성
- **스크립트 개선**: 더 직관적인 명령어
- **VS Code 통합**: 더 나은 디버깅 경험
- **문서 업데이트**: 새로운 방식 반영

---

**💡 팁**: Mock 환경에서 개발을 시작하면 서버 의존성 없이 빠르게 UI/UX 개발이 가능합니다!

**🎉 v2.0**: 더 깔끔하고 표준적인 환경 설정 방식으로 업그레이드 완료!
